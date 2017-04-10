--- AI_ZONE_INVASION
-- @module AI_Zone_Invasion

--- AI_ZONE_INVASION class
-- @type AI_ZONE_INVASION
-- @extends Core.Base#BASE
AI_ZONE_INVASION = {
  ClassName = 'AI_ZONE_INVASION',
}

--- Creates a new AI_ZONE_INVASION obejct
-- @param #AI_ZONE_INVASION self
-- @return #AI_ZONE_INVASION self
function AI_ZONE_INVASION:New()

  -- Inherits from BASE
  local self = BASE:Inherit( self, BASE:New() )
  
  self.Zones = {}
  self.SpawnZones = {}
  self.Spawns = {}

 
  return self
end


--- Adds a Zone to the Invasion
-- @param #AI_ZONE_INVASION self
-- @param #string ZoneName The name of the zone in the Mission Editor
-- @param #boolean IsSpawnZone (Optional)Set to true if starting the invasion should spawn groups in this zone.
-- @param #string Coalition (Optional) Coalition The coalition name "red","blue","neutral". Default is "neutral".
-- @param #double Probability (Optional) Probability This factor between 0 and 1 will determine the probability of a zone to be selected.
-- @return Returns the new zone object  
function AI_ZONE_INVASION:AddZone( ZoneName, IsSpawnZone)
  BASE:E({"AI_ZONE_INVASION: AddZone " .. ZoneName, "IsSpawnZone: ", IsSpawnZone })
  
  local NewZone = ZONE:New(ZoneName)
  NewZone.IsInitZone = IsInitZone or false
  NewZone.Coalition = Coalition or "neutral"
  NewZone.ThreadLevel = 0.3
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
  
  
  self.Zones[#self.Zones+1] = NewZone
  
  if IsSpawnZone == true then
    self.SpawnZones[#self.SpawnZones+1] = NewZone
  end

  return NewZone
end

--- Adds Transport to the Invasion, wich then will transport the other groups ("Attackers", etc..) to their desintation zones
-- @param #AI_ZONE_INVASION self
-- @param Functional.Spawn#SPAWN Spawn
function AI_ZONE_INVASION:AddTransport( Spawn )
  BASE:E({"AI_ZONE_INVASION: AddTrasport", Spawn })
  self.SpawnTransport = Spawn
end


--- Adds a SPAWN object to the invasion.
-- @param #AI_ZONE_INVASION self
-- @param Functional.Spawn#SPAWN Spawn The Spawn object to be used for the specified role
-- @param #string Role (Optional)The role of the groups spawn by this Element. Valid values are "Attacker", "Defender", "AAA" and "Reccon". Default is "Defender".
function AI_ZONE_INVASION:AddInvadors( Spawn, Role )
  BASE:E({"AI_ZONE_INVASION: AddInvadors", Spawn, Role })
  local NewSpawn = Spawn
  NewSpawn.Role = Role or "Defender"

  table.insert( self.Spawns, #self.Spawns + 1, NewSpawn)
  
end


--- Starts the AI
-- @param #AI_ZONE_INVASION self
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

  
end

--- Stops the AI
-- @param #AI_ZONE_INVASION self
function AI_ZONE_INVASION:Stop()
  BASE:E("AI Invasion stop")
  self.InvasionScheduler:Stop()
end

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

