--- SP:Y MP:Y AI:Y HU:N TYP:Air -- This module contains the AI_CAS_ZONE class.
--
-- ===
--
-- 1) @{#AI_CAS_ZONE} class, extends @{Core.Fsm#FSM_CONTROLLABLE}
-- ================================================================
-- The @{#AI_CAS_ZONE} class implements the core functions to CAS a @{Zone} by an AIR @{Controllable} @{Group}.
--
-- 1.1) AI_CAS_ZONE constructor:
-- ----------------------------
--
--   * @{#AI_CAS_ZONE.New}(): Creates a new AI_CAS_ZONE object.
--
-- 1.2) AI_CAS_ZONE state machine:
-- ----------------------------------
-- The AI_CAS_ZONE is a state machine: it manages the different events and states of the AIControllable it is controlling.
--
-- ### 1.2.1) AI_CAS_ZONE Events:
--
--   * @{#AI_CAS_ZONE.TakeOff}( AIControllable ):  The AI is taking-off from an airfield.
--   * @{#AI_CAS_ZONE.Hold}( AIControllable ): The AI is holding in airspace at a zone.
--   * @{#AI_CAS_ZONE.Engage}( AIControllable ): The AI is engaging the targets.
--   * @{#AI_CAS_ZONE.WeaponReleased}( AIControllable ): The AI has released a weapon to the target.
--   * @{#AI_CAS_ZONE.Destroy}( AIControllable ): The AI has destroyed a target.
--   * @{#AI_CAS_ZONE.Complete}( AIControllable ): The AI has destroyed all defined targets.
--   * @{#AI_CAS_ZONE.RTB}( AIControllable ): The AI is returning to the home base.
--
-- ### 1.2.2) AI_CAS_ZONE States:
--
--
-- ### 1.2.3) AI_CAS_ZONE state transition methods:
--
--
-- 1.3) Manage the AI_CAS_ZONE parameters:
-- ------------------------------------------
-- The following methods are available to modify the parameters of an AI_CAS_ZONE object:
--
--   * @{#AI_CAS_ZONE.SetControllable}(): Set the AIControllable.
--   * @{#AI_CAS_ZONE.GetControllable}(): Get the AIControllable.
--
-- ====
--
-- **API CHANGE HISTORY**
-- ======================
--
-- The underlying change log documents the API changes. Please read this carefully. The following notation is used:
--
--   * **Added** parts are expressed in bold type face.
--   * _Removed_ parts are expressed in italic type face.
--
-- Hereby the change log:
--
-- 2017-01-12: Initial class and API.
--
-- ===
--
-- AUTHORS and CONTRIBUTIONS
-- =========================
--
-- ### Contributions:
--
--   * **Quax**: Concept & Testing.
--   * **Pikey**: Concept & Testing.
--
-- ### Authors:
--
--   * **FlightControl**: Concept, Design & Programming.
--
--
-- @module Cas


--- AI_CAS_ZONE class
-- @type AI_CAS_ZONE
-- @field Wrapper.Controllable#CONTROLLABLE AIControllable The @{Controllable} patrolling.
-- @field Core.Zone#ZONE_BASE TargetZone The @{Zone} where the patrol needs to be executed.
-- @extends AI.AI_Patrol#AI_PATROLZONE
AI_CAS_ZONE = {
  ClassName = "AI_CAS_ZONE",
}



--- Creates a new AI_CAS_ZONE object
-- @param #AI_CAS_ZONE self
-- @param Core.Zone#ZONE_BASE PatrolZone The @{Zone} where the patrol needs to be executed.
-- @param Dcs.DCSTypes#Altitude PatrolFloorAltitude The lowest altitude in meters where to execute the patrol.
-- @param Dcs.DCSTypes#Altitude PatrolCeilingAltitude The highest altitude in meters where to execute the patrol.
-- @param Dcs.DCSTypes#Speed  PatrolMinSpeed The minimum speed of the @{Controllable} in km/h.
-- @param Dcs.DCSTypes#Speed  PatrolMaxSpeed The maximum speed of the @{Controllable} in km/h.
-- @param Core.Zone#ZONE EngageZone
-- @return #AI_CAS_ZONE self
function AI_CAS_ZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, EngageZone )

  -- Inherits from BASE
  local self = BASE:Inherit( self, AI_PATROLZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed ) ) -- #AI_CAS_ZONE

  self.PatrolZone = PatrolZone
  self.PatrolFloorAltitude = PatrolFloorAltitude
  self.PatrolCeilingAltitude = PatrolCeilingAltitude
  self.PatrolMinSpeed = PatrolMinSpeed
  self.PatrolMaxSpeed = PatrolMaxSpeed
  
  self.EngageZone = EngageZone
  
  do self:AddTransition( { "Patrol", "Route", "Engaging" }, "Engage", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_CAS_ZONE.

    --- OnLeave State Transition for Holding.
    -- @function [parent=#AI_CAS_ZONE] OnLeaveHolding
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnEnter State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnEnterEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.

    --- OnBefore State Transition for Engage.
    -- @function [parent=#AI_CAS_ZONE] OnBeforeEngage
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnAfter State Transition for Engage.
    -- @function [parent=#AI_CAS_ZONE] OnAfterEngage
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.

    --- Embedded Event Trigger for Engage.
    -- @function [parent=#AI_CAS_ZONE] Engage
    -- @param #AI_CAS_ZONE self

    --- Delayed Event Trigger for Engage
    -- @function [parent=#AI_CAS_ZONE] __Engage
    -- @param #AI_CAS_ZONE self
    -- @param #number Delay The delay in seconds.

  end -- AI_CAS_ZONE


  do self:AddTransition( "Engaging", "Fired", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_CAS_ZONE.

    --- OnLeave State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnLeaveEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnEnter State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnEnterEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.

    --- OnBefore State Transition for Fired.
    -- @function [parent=#AI_CAS_ZONE] OnBeforeFired
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnAfter State Transition for Fired.
    -- @function [parent=#AI_CAS_ZONE] OnAfterFired
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean

    --- Embedded Event Trigger for Fired.
    -- @function [parent=#AI_CAS_ZONE] Fired
    -- @param #AI_CAS_ZONE self

    --- Delayed Event Trigger for Fired
    -- @function [parent=#AI_CAS_ZONE] __Fired
    -- @param #AI_CAS_ZONE self
    -- @param #number Delay The delay in seconds.

  end -- AI_CAS_ZONE

  do self:AddTransition( "Engaging", "Destroy", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_CAS_ZONE.

    --- OnLeave State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnLeaveEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnEnter State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnEnterEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.

    --- OnBefore State Transition for Destroy.
    -- @function [parent=#AI_CAS_ZONE] OnBeforeDestroy
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.

    --- OnAfter State Transition for Destroy.
    -- @function [parent=#AI_CAS_ZONE] OnAfterDestroy
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.

    --- Embedded Event Trigger for Destroy.
    -- @function [parent=#AI_CAS_ZONE] Destroy
    -- @param #AI_CAS_ZONE self

    --- Delayed Event Trigger for Destroy
    -- @function [parent=#AI_CAS_ZONE] __Destroy
    -- @param #AI_CAS_ZONE self
    -- @param #number Delay The delay in seconds.

  end -- AI_CAS_ZONE

do self:AddTransition( "Engaging", "Abort", "Patrol" ) -- FSM_CONTROLLABLE Transition for type #AI_CAS_ZONE.

	--- OnLeave State Transition for Engaging.
  -- @function [parent=#AI_CAS_ZONE] OnLeaveEngaging
  -- @param #AI_CAS_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.

	--- OnEnter State Transition for Patrol.
  -- @function [parent=#AI_CAS_ZONE] OnEnterPatrol
  -- @param #AI_CAS_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
	
	--- OnBefore State Transition for Abort.
  -- @function [parent=#AI_CAS_ZONE] OnBeforeAbort
  -- @param #AI_CAS_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.

	--- OnAfter State Transition for Abort.
  -- @function [parent=#AI_CAS_ZONE] OnAfterAbort
  -- @param #AI_CAS_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
	
	--- Embedded Event Trigger for Abort.
  -- @function [parent=#AI_CAS_ZONE] Abort
  -- @param #AI_CAS_ZONE self

	--- Delayed Event Trigger for Abort
  -- @function [parent=#AI_CAS_ZONE] __Abort
  -- @param #AI_CAS_ZONE self
  -- @param #number Delay The delay in seconds.

end -- AI_CAS_ZONE


  do self:AddTransition( "Engaging", "Completed", "Patrol" ) -- FSM_CONTROLLABLE Transition for type #AI_CAS_ZONE.
  
  	--- OnLeave State Transition for Engaging.
    -- @function [parent=#AI_CAS_ZONE] OnLeaveEngaging
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.
  
  	--- OnEnter State Transition for Patrol.
    -- @function [parent=#AI_CAS_ZONE] OnEnterPatrol
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
  	
  	--- OnBefore State Transition for Completed.
    -- @function [parent=#AI_CAS_ZONE] OnBeforeCompleted
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
    -- @return #boolean Return false to cancel Transition.
  
  	--- OnAfter State Transition for Completed.
    -- @function [parent=#AI_CAS_ZONE] OnAfterCompleted
    -- @param #AI_CAS_ZONE self
    -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
    -- @param #string From The From State string.
    -- @param #string Event The Event string.
    -- @param #string To The To State string.
  	
  	--- Embedded Event Trigger for Completed.
    -- @function [parent=#AI_CAS_ZONE] Completed
    -- @param #AI_CAS_ZONE self
  
  	--- Delayed Event Trigger for Completed
    -- @function [parent=#AI_CAS_ZONE] __Completed
    -- @param #AI_CAS_ZONE self
    -- @param #number Delay The delay in seconds.
  
  end -- AI_CAS_ZONE

  return self
end


--- onafter State Transition for Event Start.
-- @param #AI_CAS_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_CAS_ZONE:onafterStart( Controllable, From, Event, To )


  if Controllable:IsAlive() then
    self:__Route( 1 )
  end
  
  self:EventOnDead( self.OnDead )
  
  Controllable:OptionROEHoldFire()
  Controllable:OptionROTVertical()
  
end

--- @param Wrapper.Controllable#CONTROLLABLE AIControllable
function _NewEngageRoute( AIControllable )

  AIControllable:T( "NewEngageRoute" )
  local EngageZone = AIControllable:GetState( AIControllable, "EngageZone" ) -- AI.AI_Patrol#AI_PATROLZONE
  EngageZone:__Engage( 1 )
end


--- @param #AI_CAS_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_CAS_ZONE:onafterEngage( Controllable, From, Event, To )

  if Controllable:IsAlive() then

    local EngageRoute = {}
  
    if self.Controllable:IsNotInZone( self.EngageZone ) then

      -- Find a random 2D point in EngageZone.
      local ToEngageZoneVec2 = self.EngageZone:GetRandomVec2()
      self:T2( ToEngageZoneVec2 )
      
      -- Define Speed and Altitude.
      local ToEngageZoneAltitude = math.random( self.EngageFloorAltitude, self.EngageCeilingAltitude )
      local ToEngageZoneSpeed = self.PatrolMaxSpeed
      self:T2( ToEngageZoneSpeed )
      
      -- Obtain a 3D @{Point} from the 2D point + altitude.
      local ToEngageZonePointVec3 = POINT_VEC3:New( ToEngageZoneVec2.x, ToEngageZoneAltitude, ToEngageZoneVec2.y )
      
      -- Create a route point of type air.
      local ToEngageZoneRoutePoint = ToEngageZonePointVec3:RoutePointAir( 
        POINT_VEC3.RoutePointAltType.BARO, 
        POINT_VEC3.RoutePointType.TurningPoint, 
        POINT_VEC3.RoutePointAction.TurningPoint, 
        ToEngageZoneSpeed, 
        true 
      )

      EngageRoute[#EngageRoute+1] = ToEngageZoneRoutePoint

    end
    
    --- Define a random point in the @{Zone}. The AI will fly to that point within the zone.
    
      --- Find a random 2D point in EngageZone.
    local ToTargetVec2 = self.EngageZone:GetRandomVec2()
    self:T2( ToTargetVec2 )

    --- Define Speed and Altitude.
    local ToTargetAltitude = math.random( self.EngageFloorAltitude, self.EngageCeilingAltitude )
    local ToTargetSpeed = math.random( self.PatrolMinSpeed, self.PatrolMaxSpeed )
    self:T2( { self.PatrolMinSpeed, self.PatrolMaxSpeed, ToTargetSpeed } )
    
    --- Obtain a 3D @{Point} from the 2D point + altitude.
    local ToTargetPointVec3 = POINT_VEC3:New( ToTargetVec2.x, ToTargetAltitude, ToTargetVec2.y )
    
    --- Create a route point of type air.
    local ToTargetRoutePoint = ToTargetPointVec3:RoutePointAir( 
      POINT_VEC3.RoutePointAltType.BARO, 
      POINT_VEC3.RoutePointType.TurningPoint, 
      POINT_VEC3.RoutePointAction.TurningPoint, 
      ToTargetSpeed, 
      true 
    )
    
    ToTargetPointVec3:SmokeRed()

    EngageRoute[#EngageRoute+1] = ToTargetRoutePoint
    
    --- Now we're going to do something special, we're going to call a function from a waypoint action at the AIControllable...
    self.Controllable:WayPointInitialize( EngageRoute )
    
    --- Do a trick, link the NewEngageRoute function of the PATROLGROUP object to the AIControllable in a temporary variable ...
    self.Controllable:SetState( self.Controllable, "EngageZone", self )
    self.Controllable:WayPointFunction( #EngageRoute, 1, "_NewEngageRoute" )

    --- NOW ROUTE THE GROUP!
    self.Controllable:WayPointExecute( 1, 5 )

    local DetectedTargets = Controllable:GetDetectedTargets()
    for TargetID, Target in pairs( DetectedTargets ) do
      local TargetObject = Target.object
      self:T( TargetObject )
      if TargetObject and TargetObject:isExist() and TargetObject.id_ < 50000000 then
  
        local TargetUnit = UNIT:Find( TargetObject )
        local TargetUnitName = TargetUnit:GetName()
        
        if TargetUnit:IsInZone( self.EngageZone ) then
          --local EngageTask = Controllable:EnRouteTaskEngageUnit( TargetUnit, 1 )
          local EngageTask = Controllable:TaskAttackUnit( TargetUnit )
          Controllable:PushTask( EngageTask, 1 )
        end
      end
    end
    
    Controllable:OptionROEWeaponFree()
    Controllable:OptionROTPassiveDefense()
    
  end
end

--- @param #AI_CAS_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_CAS_ZONE:onafterDestroy( Controllable, From, Event, To )

  Controllable:MessageToAll( "Destroyed a target", 15 , "Destroyed!" )
end

--- @param #AI_CAS_ZONE self
-- @param Core.Event#EVENTDATA EventData
function AI_CAS_ZONE:OnDead( EventData )
  self:T( { "EventDead", EventData } )

  if EventData.IniDCSUnit then
    self:__Destroy( 1, EventData )
  end
end


