--- AI_ZONE_INVASION
-- @module AI_Zone_Invasion

--- AI_ZONE_INVASION class
-- @type AI_ZONE_INVASION
-- @extends Core.Fsm#FSM_SET
AI_ZONE_INVASION = {
  ClassName = 'AI_ZONE_INVASION',
  Zones = {},
}

--- Creates a new AI_ZONE_INVASION obejct
-- @param #AI_ZONE_INVASION self
-- @param #table Zones A table with all zonenames
-- @return #AI_ZONE_INVASION self
function AI_ZONE_INVASION:New( Zones )

  -- Inherits from BASE
  local self = BASE:Inherit( self, FSM_SET:New( SET_GROUP:New() ) )
  
  -- Create extended zones
  local ZoneNames = Zones or {}
  local index = 0
  for index, Name in pairs (ZoneNames) do
    
    local NewZone = ZONE:New( Name )
    NewZone.Coalition = Coalition or "neutral"
    NewZone.ThreadLevel = 0.0
    
    function NewZone:SetThreadLevel( value )
      self.ThreadLevel = value
    end
    function NewZone:DecreaseThreadLevel( value )
      if self.ThreadLevel - value < 0.0 then
        self.ThreadLevel = 0
      else
        self.ThreadLevel = value - value
      end
    end
    function NewZone:IncreaseThreadLevel( value )
      self.ThreadLevel = value + value      
    end
    
    self.SetZones[index] = NewZone
     
  end
  
  --Create Transitions for the group Sets
  self:SetStartState( "None" )
  self:AddTransition( "*", "Monitor", "Monitoring" )
  self:AddTransition( "*", "Spawn", "Spawning" )
  self:AddTransition( "Spawning", "Spawned", "Spawned" )
  self:AddTransition( "*", "Destroy", "Destroying" )

  return self
end


--- Adds a Zone to the Invasion
-- @param #AI_ZONE_INVASION self
-- @param #string ZoneName The name of the zone in the Mission Editor
-- @param #boolean IsSpawnZone (Optional)Set to true if starting the invasion should spawn groups in this zone.
-- @param #string Coalition (Optional) Coalition The coalition name "red","blue","neutral". Default is "neutral".
-- @param #double Probability (Optional) Probability This factor between 0 and 1 will determine the probability of a zone to be selected.
-- @return Returns the new zone object  
function AI_ZONE_INVASION:SetSpawnZone( ZoneName )
  BASE:E({"AI_ZONE_INVASION: Setting SpawnZone to: " .. ZoneName })
  
  local NewZone = ZONE:New(ZoneName)
  NewZone.IsInitZone = IsInitZone or false

  
  
  self.Zones[#self.Zones+1] = NewZone
  
  if IsSpawnZone == true then
    self.SpawnZones[#self.SpawnZones+1] = NewZone
  end

  return NewZone
end


--- Adds Transport to the Invasion, wich then will transport the other groups ("Attackers", etc..) to their desintation zones
-- @param #AI_ZONE_INVASION self
-- @param #table Attackers A single String or a table of groupnames defined within the ME wich will act as transporters in the invasion. In case of a table the template will be randomized
function AI_ZONE_INVASION:AddTransport( TransporterGroupNames )
  
  BASE:E({"AI_ZONE_INVASION: AddTransports", TransporterGroupNames })
  local Transporters = TransporterGroupNames or {TransporterGroupNames} 
  self.SpawnAttackers = SPAWN:New():InitRandomizeTemplate(Transporters)
  
end

--- Adds a SPAWN object to the invasion.
-- @param #AI_ZONE_INVASION self
-- @param #table Attackers A single String or a table of groupnames defined within the ME wich will act as attackers in the invasion. In case of a table the template will be randomized
function AI_ZONE_INVASION:AddAttackers( AttackerGroupNames )
  
  BASE:E({"AI_ZONE_INVASION: AddAttackers", AttackerGroupNames })
  local Attackers = AttackerGroupNames or {AttackerGroupNames} 
  self.SpawnAttackers = SPAWN:New():InitRandomizeTemplate(Attackers)
  
end

--- Adds a SPAWN object to the invasion.
-- @param #AI_ZONE_INVASION self
-- @param #table Attackers A single String or a table of groupnames defined within the ME wich will act as defenders in the invasion. In case of a table the template will be randomized
function AI_ZONE_INVASION:AddDefenders( DefenderGroupNames )
  
  BASE:E({"AI_ZONE_INVASION: AddAttackers", DefenderGroupNames })
  local Defenders = DefenderGroupNames or {DefenderGroupNames} 
  self.SpawnDefenders = SPAWN:New():InitRandomizeTemplate(Defenders)
  
end

--- @param #AI_ZONE_INVASION self
function AI_ZONE_INVASION:Start()
  BASE:E("AI Invasion start")  
  self.InvasionScheduler = SCHEDULER:New(nil,
    --- @param #AI_ZONE_INVASION
    function( invasion )
      if invasion.SpawnTransport ~= nil then
        invasion:_SpawnTransport()
      else
        invasion:_SpawnGroup()
      end
       
    end,
    {self}, 10, 30  )
  self:__Monitor( 1 )
end

--- Stops the AI
-- @param #AI_ZONE_INVASION self
function AI_ZONE_INVASION:Stop()
  BASE:E("AI Invasion stop")
  self.InvasionScheduler:Stop()
end

--- Spawns a transport into the invasion
-- @params self
function AI_ZONE_INVASION:_SpawnTransport()

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
function AI_ZONE_INVASION:_SpawnGroup()

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
-- @param #AI_ZONE_INVASION self
-- @param Wrapper.Group#GROUP group 
function AI_ZONE_INVASION:_SetFSM_Attack( group )
    
    local attackFSM = FSM_CONTROLLABLE:New(group)
    attackFSM:SetStartState("None")
    attackFSM:AddTransition("None","Activate","Idle")
    attackFSM:AddTransition("Idle","Tasking","Moving")
    attackFSM:AddTransition("Moving","TaskComplete","Idle")
    attackFSM:AddTransition("*","Deactivating","None")
    
end

