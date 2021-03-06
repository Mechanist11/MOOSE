--- **Core** -- **SETTINGS** classe defines the format settings management for measurement.
--
-- ![Banner Image](..\Presentations\SETTINGS\Dia1.JPG)
--
-- ====
--
-- # Demo Missions
--
-- ### [SETTINGS Demo Missions source code]()
--
-- ### [SETTINGS Demo Missions, only for beta testers]()
--
-- ### [ALL Demo Missions pack of the last release](https://github.com/FlightControl-Master/MOOSE_MISSIONS/releases)
--
-- ====
--
-- # YouTube Channel
--
-- ### [SETTINGS YouTube Channel]()
--
-- ===
-- 
-- ### Author: **Sven Van de Velde (FlightControl)**
-- ### Contributions: 
-- 
-- ====
--
-- @module Settings


--- @type SETTINGS
-- @field #number LL_Accuracy
-- @field #boolean LL_DMS
-- @field #number MGRS_Accuracy
-- @field #string A2GSystem
-- @field #string A2ASystem
-- @extends Core.Base#BASE

--- # SETTINGS class, extends @{Base#BASE}
--
-- @field #SETTINGS
SETTINGS = {
  ClassName = "SETTINGS",
}



do -- SETTINGS

  --- SETTINGS constructor.
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:Set( PlayerName ) 

    if PlayerName == nil then
      local self = BASE:Inherit( self, BASE:New() ) -- #SETTINGS
      self:SetMetric() -- Defaults
      self:SetA2G_BR() -- Defaults
      self:SetA2A_BRAA() -- Defaults
      self:SetLL_Accuracy( 2 ) -- Defaults
      self:SetLL_DMS( true ) -- Defaults
      self:SetMGRS_Accuracy( 5 ) -- Defaults
      return self
    else
      local Settings = _DATABASE:GetPlayerSettings( PlayerName )
      if not Settings then
        Settings = BASE:Inherit( self, BASE:New() ) -- #SETTINGS
        _DATABASE:SetPlayerSettings( PlayerName, Settings )
      end
      return Settings
    end
  end
  
 
  --- Sets the SETTINGS metric.
  -- @param #SETTINGS self
  function SETTINGS:SetMetric()
    self.Metric = true
  end
 
  --- Gets if the SETTINGS is metric.
  -- @param #SETTINGS self
  -- @return #boolean true if metric.
  function SETTINGS:IsMetric()
    self:E( {Metric = ( self.Metric ~= nil and self.Metric == true ) or ( self.Metric == nil and _SETTINGS:IsMetric() ) } )
    return ( self.Metric ~= nil and self.Metric == true ) or ( self.Metric == nil and _SETTINGS:IsMetric() )
  end

  --- Sets the SETTINGS imperial.
  -- @param #SETTINGS self
  function SETTINGS:SetImperial()
    self.Metric = false
  end
 
  --- Gets if the SETTINGS is imperial.
  -- @param #SETTINGS self
  -- @return #boolean true if imperial.
  function SETTINGS:IsImperial()
    self:E( {Metric = ( self.Metric ~= nil and self.Metric == false ) or ( self.Metric == nil and _SETTINGS:IsMetric() ) } )
    return ( self.Metric ~= nil and self.Metric == false ) or ( self.Metric == nil and _SETTINGS:IsMetric() )
  end

  --- Sets the SETTINGS LL accuracy.
  -- @param #SETTINGS self
  -- @param #number LL_Accuracy
  -- @return #SETTINGS
  function SETTINGS:SetLL_Accuracy( LL_Accuracy )
    self.LL_Accuracy = LL_Accuracy
  end

  --- Gets the SETTINGS LL accuracy.
  -- @param #SETTINGS self
  -- @return #number
  function SETTINGS:GetLL_Accuracy()
    return self.LL_Accuracy or _SETTINGS:GetLL_Accuracy()
  end

  --- Sets the SETTINGS LL DMS.
  -- @param #SETTINGS self
  -- @param #number LL_DMS
  -- @return #SETTINGS
  function SETTINGS:SetLL_DMS( LL_DMS )
    self.LL_DMS = LL_DMS
  end

  --- Gets the SETTINGS LL DMS.
  -- @param #SETTINGS self
  -- @return #number
  function SETTINGS:GetLL_DMS()
    return self.LL_DMS or _SETTINGS:GetLL_DMS()
  end
  
  --- Sets the SETTINGS MGRS accuracy.
  -- @param #SETTINGS self
  -- @param #number MGRS_Accuracy
  -- @return #SETTINGS
  function SETTINGS:SetMGRS_Accuracy( MGRS_Accuracy )
    self.MGRS_Accuracy = MGRS_Accuracy
  end

  --- Gets the SETTINGS MGRS accuracy.
  -- @param #SETTINGS self
  -- @return #number
  function SETTINGS:GetMGRS_Accuracy()
    return self.MGRS_Accuracy or _SETTINGS:GetMGRS_Accuracy()
  end
  
  


  --- Sets A2G LL
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2G_LL()
    self.A2GSystem = "LL"
  end

  --- Is LL
  -- @param #SETTINGS self
  -- @return #boolean true if LL
  function SETTINGS:IsA2G_LL()
    return ( self.A2GSystem and self.A2GSystem == "LL" ) or ( not self.A2GSystem and _SETTINGS:IsA2G_LL() )
  end

  --- Sets A2G MGRS
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2G_MGRS()
    self.A2GSystem = "MGRS"
  end

  --- Is MGRS
  -- @param #SETTINGS self
  -- @return #boolean true if MGRS
  function SETTINGS:IsA2G_MGRS()
    return ( self.A2GSystem and self.A2GSystem == "MGRS" ) or ( not self.A2GSystem and _SETTINGS:IsA2G_MGRS() )
  end

  --- Sets A2G BRA
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2G_BR()
    self.A2GSystem = "BR"
  end

  --- Is BRA
  -- @param #SETTINGS self
  -- @return #boolean true if BRA
  function SETTINGS:IsA2G_BR()
    self:E( { BRA = ( self.A2GSystem and self.A2GSystem == "BR" ) or ( not self.A2GSystem and _SETTINGS:IsA2G_BR() ) } )
    return ( self.A2GSystem and self.A2GSystem == "BR" ) or ( not self.A2GSystem and _SETTINGS:IsA2G_BR() )
  end

  --- Sets A2A BRA
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2A_BRAA()
    self.A2ASystem = "BRAA"
  end

  --- Is BRA
  -- @param #SETTINGS self
  -- @return #boolean true if BRA
  function SETTINGS:IsA2A_BRAA()
    self:E( { BRA = ( self.A2ASystem and self.A2ASystem == "BRAA" ) or ( not self.A2ASystem and _SETTINGS:IsA2A_BRAA() ) } )
    return ( self.A2ASystem and self.A2ASystem == "BRAA" ) or ( not self.A2ASystem and _SETTINGS:IsA2A_BRAA() )
  end

  --- Sets A2A BULLS
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2A_BULLS()
    self.A2ASystem = "BULLS"
  end

  --- Is BULLS
  -- @param #SETTINGS self
  -- @return #boolean true if BULLS
  function SETTINGS:IsA2A_BULLS()
    return ( self.A2ASystem and self.A2ASystem == "BULLS" ) or ( not self.A2ASystem and _SETTINGS:IsA2A_BULLS() )
  end

  --- Sets A2A LL
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2A_LL()
    self.A2ASystem = "LL"
  end

  --- Is LL
  -- @param #SETTINGS self
  -- @return #boolean true if LL
  function SETTINGS:IsA2A_LL()
    return ( self.A2ASystem and self.A2ASystem == "LL" ) or ( not self.A2ASystem and _SETTINGS:IsA2A_LL() )
  end

  --- Sets A2A MGRS
  -- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetA2A_MGRS()
    self.A2ASystem = "MGRS"
  end

  --- Is MGRS
  -- @param #SETTINGS self
  -- @return #boolean true if MGRS
  function SETTINGS:IsA2A_MGRS()
    return ( self.A2ASystem and self.A2ASystem == "MGRS" ) or ( not self.A2ASystem and _SETTINGS:IsA2A_MGRS() )
  end

  --- @param #SETTINGS self
  -- @return #SETTINGS
  function SETTINGS:SetSystemMenu( MenuGroup, RootMenu )

    local MenuText = "System Settings"
    
    local MenuTime = timer.getTime()
    
    local SettingsMenu = MENU_GROUP:New( MenuGroup, MenuText, RootMenu ):SetTime( MenuTime )

    local A2GCoordinateMenu = MENU_GROUP:New( MenuGroup, "A2G Coordinate System", SettingsMenu ):SetTime( MenuTime )
  
    if self:IsA2G_LL() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bearing, Range (BR)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "BR" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "MGRS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 1", A2GCoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 1 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 2", A2GCoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 2 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 3", A2GCoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 3 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Decimal On", A2GCoordinateMenu, self.MenuLL_DMS, self, MenuGroup, RootMenu, true ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Decimal Off", A2GCoordinateMenu, self.MenuLL_DMS, self, MenuGroup, RootMenu, false ):SetTime( MenuTime )
    end
  
    if self:IsA2G_MGRS() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bearing, Range (BR)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "BR" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "LL" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 1", A2GCoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 1 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 2", A2GCoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 2 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 3", A2GCoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 3 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 4", A2GCoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 4 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 5", A2GCoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 5 ):SetTime( MenuTime )
    end

    if self:IsA2G_BR() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "MGRS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL)", A2GCoordinateMenu, self.A2GMenuSystem, self, MenuGroup, RootMenu, "LL" ):SetTime( MenuTime )
    end

    local A2ACoordinateMenu = MENU_GROUP:New( MenuGroup, "A2A Coordinate System", SettingsMenu ):SetTime( MenuTime )

    if self:IsA2A_BULLS() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BRAA" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "MGRS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "LL" ):SetTime( MenuTime )
    end
  
    if self:IsA2A_BRAA() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BULLS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "MGRS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "LL" ):SetTime( MenuTime )
    end

    if self:IsA2A_LL() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BRAA" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BULLS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "MGRS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 1", A2ACoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 1 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 2", A2ACoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 2 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Accuracy 3", A2ACoordinateMenu, self.MenuLL_Accuracy, self, MenuGroup, RootMenu, 3 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Decimal On", A2ACoordinateMenu, self.MenuLL_DMS, self, MenuGroup, RootMenu, true ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL) Decimal Off", A2ACoordinateMenu, self.MenuLL_DMS, self, MenuGroup, RootMenu, false ):SetTime( MenuTime )
    end
  
    if self:IsA2A_MGRS() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BRAA" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "BULLS" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.A2AMenuSystem, self, MenuGroup, RootMenu, "LL" ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 1", A2ACoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 1 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 2", A2ACoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 2 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 3", A2ACoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 3 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 4", A2ACoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 4 ):SetTime( MenuTime )
      MENU_GROUP_COMMAND:New( MenuGroup, "Military Grid (MGRS) Accuracy 5", A2ACoordinateMenu, self.MenuMGRS_Accuracy, self, MenuGroup, RootMenu, 5 ):SetTime( MenuTime )
    end

    
    local MetricsMenu = MENU_GROUP:New( MenuGroup, "Measures and Weights System", SettingsMenu ):SetTime( MenuTime )
    
    if self:IsMetric() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Imperial (Miles,Feet)", MetricsMenu, self.MenuMWSystem, self, MenuGroup, RootMenu, false ):SetTime( MenuTime )
    end
    
    if self:IsImperial() then
      MENU_GROUP_COMMAND:New( MenuGroup, "Metric (Kilometers,Meters)", MetricsMenu, self.MenuMWSystem, self, MenuGroup, RootMenu, true ):SetTime( MenuTime )
    end    

    SettingsMenu:Remove( MenuTime )
    
    return self
  end

  --- @param #SETTINGS self
  -- @param RootMenu
  -- @param Wrapper.Client#CLIENT PlayerUnit
  -- @param #string MenuText
  -- @return #SETTINGS
  function SETTINGS:SetPlayerMenu( PlayerUnit )

    local PlayerGroup = PlayerUnit:GetGroup()
    local PlayerName = PlayerUnit:GetPlayerName()
    local PlayerNames = PlayerGroup:GetPlayerNames()

    local PlayerMenu = MENU_GROUP:New( PlayerGroup, 'Settings "' .. PlayerName .. '"' )
    
    self.PlayerMenu = PlayerMenu

    local A2GCoordinateMenu = MENU_GROUP:New( PlayerGroup, "A2G Coordinate System", PlayerMenu )
  
    if self:IsA2G_LL() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bearing, Range (BR)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "BR" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "MGRS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 1", A2GCoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 1 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 2", A2GCoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 2 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 3", A2GCoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 3 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Decimal On", A2GCoordinateMenu, self.MenuGroupLL_DMSSystem, self, PlayerUnit, PlayerGroup, PlayerName, true )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Decimal Off", A2GCoordinateMenu, self.MenuGroupLL_DMSSystem, self, PlayerUnit, PlayerGroup, PlayerName, false )
    end
  
    if self:IsA2G_MGRS() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bearing Range (BR)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "BR" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "LL" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 1", A2GCoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 1 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 2", A2GCoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 2 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 3", A2GCoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 3 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 4", A2GCoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 4 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 5", A2GCoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 5 )
    end

    if self:IsA2G_BR() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "MGRS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL)", A2GCoordinateMenu, self.MenuGroupA2GSystem, self, PlayerUnit, PlayerGroup, PlayerName, "LL" )
    end

    local A2ACoordinateMenu = MENU_GROUP:New( PlayerGroup, "A2A Coordinate System", PlayerMenu )

    if self:IsA2A_BULLS() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BRAA" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "MGRS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "LL" )
    end
  
    if self:IsA2A_BRAA() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BULLS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "MGRS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "LL" )
    end

    if self:IsA2A_LL() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BRAA" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BULLS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "MGRS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 1", A2ACoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 1 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 2", A2ACoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 2 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Accuracy 3", A2ACoordinateMenu, self.MenuGroupLL_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 3 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Decimal On", A2ACoordinateMenu, self.MenuGroupLL_DMSSystem, self, PlayerUnit, PlayerGroup, PlayerName, true )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL) Decimal Off", A2ACoordinateMenu, self.MenuGroupLL_DMSSystem, self, PlayerUnit, PlayerGroup, PlayerName, false )
    end
  
    if self:IsA2A_MGRS() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bearing Range Altitude Aspect (BRAA)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BRAA" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Bullseye (BULLS)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "BULLS" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Lattitude Longitude (LL)", A2ACoordinateMenu, self.MenuGroupA2ASystem, self, PlayerUnit, PlayerGroup, PlayerName, "LL" )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 1", A2ACoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 1 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 2", A2ACoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 2 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 3", A2ACoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 3 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 4", A2ACoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 4 )
      MENU_GROUP_COMMAND:New( PlayerGroup, "Military Grid (MGRS) Accuracy 5", A2ACoordinateMenu, self.MenuGroupMGRS_AccuracySystem, self, PlayerUnit, PlayerGroup, PlayerName, 5 )
    end

    local MetricsMenu = MENU_GROUP:New( PlayerGroup, "Measures and Weights System", PlayerMenu )
    
    if self:IsMetric() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Imperial (Miles,Feet)", MetricsMenu, self.MenuGroupMWSystem, self, PlayerUnit, PlayerGroup, PlayerName, false )
    end
    
    if self:IsImperial() then
      MENU_GROUP_COMMAND:New( PlayerGroup, "Metric (Kilometers,Meters)", MetricsMenu, self.MenuGroupMWSystem, self, PlayerUnit, PlayerGroup, PlayerName, true )
    end    
    
    return self
  end

  --- @param #SETTINGS self
  -- @param RootMenu
  -- @param Wrapper.Client#CLIENT PlayerUnit
  -- @return #SETTINGS
  function SETTINGS:RemovePlayerMenu( PlayerUnit )

    if self.PlayerMenu then
      self.PlayerMenu:Remove()
    end
    
    return self
  end


  --- @param #SETTINGS self
  function SETTINGS:A2GMenuSystem( MenuGroup, RootMenu, A2GSystem )
    self.A2GSystem = A2GSystem
    MESSAGE:New( string.format("Settings: Default A2G coordinate system set to %s for all players!.", A2GSystem ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  --- @param #SETTINGS self
  function SETTINGS:A2AMenuSystem( MenuGroup, RootMenu, A2ASystem )
    self.A2ASystem = A2ASystem
    MESSAGE:New( string.format("Settings: Default A2A coordinate system set to %s for all players!.", A2ASystem ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  --- @param #SETTINGS self
  function SETTINGS:MenuLL_Accuracy( MenuGroup, RootMenu, LL_Accuracy )
    self.LL_Accuracy = LL_Accuracy
    MESSAGE:New( string.format("Settings: Default LL accuracy set to %s for all players!.", LL_Accuracy ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  --- @param #SETTINGS self
  function SETTINGS:MenuLL_DMS( MenuGroup, RootMenu, LL_DMS )
    self.LL_DMS = LL_DMS
    MESSAGE:New( string.format("Settings: Default LL format set to %s for all players!.", LL_DMS or "Decimal" or "HMS" ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  --- @param #SETTINGS self
  function SETTINGS:MenuMGRS_Accuracy( MenuGroup, RootMenu, MGRS_Accuracy )
    self.MGRS_Accuracy = MGRS_Accuracy
    MESSAGE:New( string.format("Settings: Default MGRS accuracy set to %s for all players!.", MGRS_Accuracy ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  --- @param #SETTINGS self
  function SETTINGS:MenuMWSystem( MenuGroup, RootMenu, MW )
    self.Metric = MW
    MESSAGE:New( string.format("Settings: Default measurement format set to %s for all players!.", MW and "Metric" or "Imperial" ), 5 ):ToAll()
    self:SetSystemMenu( MenuGroup, RootMenu )
  end

  do
    --- @param #SETTINGS self
    function SETTINGS:MenuGroupA2GSystem( PlayerUnit, PlayerGroup, PlayerName, A2GSystem )
      BASE:E( {self, PlayerUnit:GetName(), A2GSystem} )
      self.A2GSystem = A2GSystem
      MESSAGE:New( string.format("Settings: A2G format set to %s for player %s.", A2GSystem, PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end
  
    --- @param #SETTINGS self
    function SETTINGS:MenuGroupA2ASystem( PlayerUnit, PlayerGroup, PlayerName, A2ASystem )
      self.A2ASystem = A2ASystem
      MESSAGE:New( string.format("Settings: A2A format set to %s for player %s.", A2ASystem, PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end
  
    --- @param #SETTINGS self
    function SETTINGS:MenuGroupLL_AccuracySystem( PlayerUnit, PlayerGroup, PlayerName, LL_Accuracy )
      self.LL_Accuracy = LL_Accuracy
      MESSAGE:New( string.format("Settings: A2G LL format accuracy set to %d for player %s.", LL_Accuracy, PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end
  
    --- @param #SETTINGS self
    function SETTINGS:MenuGroupLL_DMSSystem( PlayerUnit, PlayerGroup, PlayerName, LL_DMS )
      self.LL_DMS = LL_DMS
      MESSAGE:New( string.format("Settings: A2G LL format mode set to %s for player %s.", LL_DMS and "Decimal" or "HMS", PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end

    --- @param #SETTINGS self
    function SETTINGS:MenuGroupMGRS_AccuracySystem( PlayerUnit, PlayerGroup, PlayerName, MGRS_Accuracy )
      self.MGRS_Accuracy = MGRS_Accuracy
      MESSAGE:New( string.format("Settings: A2G MGRS format accuracy set to %d for player %s.", MGRS_Accuracy, PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end

    --- @param #SETTINGS self
    function SETTINGS:MenuGroupMWSystem( PlayerUnit, PlayerGroup, PlayerName, MW )
      self.Metric = MW
      MESSAGE:New( string.format("Settings: Measurement format set to %s for player %s.", MW and "Metric" or "Imperial", PlayerName ), 5 ):ToGroup( PlayerGroup )
      self:RemovePlayerMenu(PlayerUnit)
      self:SetPlayerMenu(PlayerUnit)
    end
  
  end

end


