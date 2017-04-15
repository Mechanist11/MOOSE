--- AI_INVASION
-- @module AI_Invasion

--- AI_INVASION class
-- @type AI_INVASION
-- @extends Core.Fsm#FSM_SET
AI_INVASION = {
  ClassName = 'AI_INVASION',
  Zones = {},
}

--- Creates a new AI_INVASION obejct
-- @param #AI_INVASION self
-- @param #table Zones A table with all zonenames
-- @param #string Coalition The coalition this invasion is 
-- @return #AI_INVASION self
function AI_INVASION:New( Zones , Coalition )

  BASE:T({"AI_INVASION: New for Zones ", Zones, Coalition})
  -- Inherits from BASE
  local self = BASE:Inherit( self, FSM_SET:New( SET_GROUP:New() ) )
  
  self.Coalition = Coalition
  
  -- GroupSet
  self.Groups = SET_GROUP:New():FilterCoalitions(self.Coalition):FilterStart()
  
  -- Create extended zones
  for index, ZoneData in pairs (Zones or {}) do
    local Zone = ZoneData -- Core.Zone#ZONE_BASE
    
    local NewZone = ZONE:New( Name )
    NewZone.Coalition = Coalition or "neutral"
    NewZone.Priority = 0.0
    NewZone.ThreadLevel = 0.0
    
    self.SetZones[index] = NewZone
     
  end
  
  --Create Transitions for the Invasion
  self:SetStartState( "None" )
  self:AddTransition( "*", "Monitor", "Monitoring" )
  self:AddTransition( "*", "Spawn", "Spawning" )


  return self
end

function AI_INVASION:SetZonePriority( ZoneName, Priority )
  
  local missionzone, index = self._FindZone( ZoneName )
  if missionzone then
    BASE:T({"AI_INVASION: Setting zone priority: " .. ZoneName,  priority})
    self.Zones[index].Priority = Priority 
  else
    BASE:T({"AI_INVASION: Setting zone priority: Zone " .. ZoneName .. " not found!"})
  end
  
end

--- Sets a Zone as SpawnZone
-- @param #AI_INVASION self
-- @param #string ZoneName The name of the zone in the Mission Editor
function AI_INVASION:SetSpawnZone( ZoneName )
  
  BASE:T("AI_INVASION: Setting SpawnZone to: " .. ZoneName )
  
  local Zone = self:_FindZone( ZoneName )
  
  if Zone then
   NewZone.IsSpawnZone = true 
  end
  
end

--- Adds Transport to the Invasion, wich then will transport the other groups ("Attackers", etc..) to their desintation zones
-- @param #AI_INVASION self
-- @param #table TransporterGroupNames A single String or a table of groupnames defined within the ME wich will act as transporters in the invasion. In case of a table the template will be randomized
function AI_INVASION:AddTransport( TransporterGroupNames )
  
  BASE:T({"AI_INVASION: AddTransports", TransporterGroupNames })
  local Transporters = TransporterGroupNames or {TransporterGroupNames} 
  self.SpawnTransporters = SPAWN:New():InitRandomizeTemplate(Transporters)
  
end

--- Adds a SPAWN object to the invasion.
-- @param #AI_INVASION self
-- @param #table AttackerGroupNames A single String or a table of groupnames defined within the ME wich will act as attackers in the invasion. In case of a table the template will be randomized
function AI_INVASION:AddAttackers( AttackerGroupNames )
  
  BASE:T({"AI_INVASION: AddAttackers", AttackerGroupNames })
  local Attackers = AttackerGroupNames or {AttackerGroupNames} 
  self.SpawnAttackers = SPAWN:New():InitRandomizeTemplate(Attackers)
  
end

--- Adds a SPAWN object to the invasion.
-- @param #AI_INVASION self
-- @param #table DefenderGroupNames A single String or a table of groupnames defined within the ME wich will act as defenders in the invasion. In case of a table the template will be randomized
function AI_INVASION:AddDefenders( DefenderGroupNames )
  
  BASE:T({"AI_INVASION: AddAttackers", DefenderGroupNames })
  local Defenders = DefenderGroupNames or {DefenderGroupNames} 
  self.SpawnDefenders = SPAWN:New():InitRandomizeTemplate(Defenders)
  
end

--- @param #AI_INVASION self
function AI_INVASION:Start()
  BASE:E("AI Invasion start")  

  self:__Monitor( 1 )
end

--- Stops the AI
-- @param #AI_INVASION self
function AI_INVASION:Stop()
  BASE:E("AI Invasion stop")
  self.InvasionScheduler:Stop()
end


function AI_INVASION:_FindZone( ZoneName )

  for i, zone in pairs ( self.Zones ) do
    if zone:GetName() == ZoneName then
      return zone, i
    end
  end
  
  return nil
end

--- Spawns a transport into the invasion
-- @params self
function AI_INVASION:_SpawnTransport()

  local transporter = self.SpawnTransport:SpawnInZone( self.SpawnZones[16],true ) --math.random(#self.SpawnZones)
  
  transporter:TaskLandAtZone(self.Zones[18],30,true) --math.random(#self.Zones)
  transporter.RTB = false
  transporter:TaskLandAtZone(self.SpawnZones[math.random(#self.SpawnZones)],30,true)
  transporter:HandleEvent(EVENTS.Land)
  function transporter:OnEventLand(EventData)
    if self.RTB == false then
      self:TaskLandAtZone(self.SpawnZones[math.random(#self.SpawnZones)],30,true)
      self.RTB = true
    else
      self.TaskLandAtZone(self.Zones[math.random(#self.Zones)], 30, true)
      self.RTB = false
    end
  end
  return transporter
end

--- Spawns a Group into the invasion
-- @params self
function AI_INVASION:_SpawnGroup()

  for index,spawn in pairs( self.Spawns ) do
    zone = self.SpawnZones[math.random(#self.SpawnZones)]        
    group = spawn:SpawnInZone( zone , true )
    group.CurrentZone = zone
    group:HandleEvent(EVENTS.Shot)
    function group:OnEventShot(EventData)
      if self.CurrentZone ~= nil then
        self.CurrentZone:IncreaseThreadLevel()
      end
    end
    group:HandleEvent(EVENTS.Dead)
    
  end

end

--- Set an aggressive FSM to the controllable
-- @param #AI_INVASION self
-- @param Wrapper.Group#GROUP group 
function AI_INVASION:_SetFSM_Attack( group )
    
    local attackFSM = FSM_CONTROLLABLE:New(group)
    attackFSM:SetStartState("None")
    attackFSM:AddTransition("None","Activate","Idle")
    attackFSM:AddTransition("Idle","Tasking","Moving")
    attackFSM:AddTransition("Moving","TaskComplete","Idle")
    attackFSM:AddTransition("*","Deactivating","None")
    
    
    return attackFSM
end


---
-- @param #AI_INVATION self
-- @param Core.Set#SET GroupSet
-- @param From
-- @param Event
-- @param To
function AI_INVASION:onenterMonitoring( GroupSet, From, Event, To )
  
  BASE:T("AI_INVASION: Monitoring")
  --Check all zones and decrease the threadlevel if own troops are inside
--  local zone = self.Zones
--  self.GroupSet:ForEachGroup(
--    --- @param Wrapper.Group#GROUP group
--    function(group)
--      
--      for i, zone in pairs ( self.Zones ) do
--        if group:IsCompletelyInZone(zone) then
--          zone:DecreaseThreadLevel( #group:GetUnits() )
--        end
--      end
--      
--    end
--  )
  
  self:__Monitor( -10 )
end






--- AI_INVASION_ZONE class
-- @type AI_INVASION_ZONE
-- @extends Core.Zones#ZONE
AI_INVASION_ZONE = {
  ClassName = 'AI_INVASION_ZONE',
}


function AI_INVASION_ZONE:New( ZoneName )
  
  BASE:T("AI_INVASION_ZONE: New")
  
end
