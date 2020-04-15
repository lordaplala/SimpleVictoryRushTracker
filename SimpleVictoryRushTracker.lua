------------------------------------------------------------------------------
-- "Constants"

-- Default values for configurable options
local svrt_CNF_DEF_ENABLED = true;
local svrt_CNF_DEF_SOUND = true;
local svrt_CNF_DEF_SIZE = 32;

local svrt_is_vr_usable = false;

------------------------------------------------------------------------------
function svrt_init()
    local _, class = UnitClass("player");
    if (class ~= "WARRIOR") then
        svrt_Icon:Hide();
        return;
    end
    svrt_localize();
    svrt_EventHandler:SetScript("OnUpdate", svrt_eventUpdate);
    svrt_EventHandler:Show();
    svrt_registerSlash();
    svrt_cnfGet();
    svrt_updateIconCnf();
end

function svrt_localize()
    local loc = GetLocale();
    if (loc == "deDE") then
        svrt_de();
    elseif (loc == "frFR") then
        svrt_fr();
    elseif (loc == "esES") then
        svrt_es();
    else
        svrt_en();
    end
end

-- Registers the /vr command
function svrt_registerSlash()
    SlashCmdList["VR"] = svrt_handler;
    SLASH_VR1 = "/vr";
end

------------------------------------------------------------------------------
-- Updates according to the configuration
function svrt_updateIconCnf()
    svrt_Icon:SetWidth(svrt_cnf.size);
    svrt_Icon:SetHeight(svrt_cnf.size);
    if (svrt_cnf.enabled) then
        svrt_Icon:Show();
    else
        svrt_Icon:Hide();
    end
end

-- Called every frame
function svrt_eventUpdate()
    if IsUsableSpell(svrt_VICTORY_RUSH) then
        if (svrt_is_vr_usable == false) then
            if (svrt_cnf.sound) then
                PlaySound("LEVELUPSOUND");
            end
        end
        svrt_is_vr_usable = true;
        svrt_Icon:SetAlpha(1);
    else
        svrt_is_vr_usable = false;
        svrt_Icon:SetAlpha(0.4);
    end
end

------------------------------------------------------------------------------
-- Slash-command handler for /vr
function svrt_handler(msg)
    svrt_ConfigFrame:Show();
end

------------------------------------------------------------------------------
-- Retrieves current configuration
function svrt_cnfGet()
    if (not svrt_cnf) then
        svrt_cnf = {};
    end
    if (not svrt_cnf.enabled) then
        svrt_cnf.enabled = svrt_CNF_DEF_ENABLED;
    end
    if (not svrt_cnf.sound) then
        svrt_cnf.sound = svrt_CNF_DEF_SOUND;
    end
    if (not svrt_cnf.size) then
        svrt_cnf.size = svrt_CNF_DEF_SIZE;
    end
    svrt_cnfVariablesLoaded = true;
end

-- Called each time the configuration window is shown
function svrt_cnfOnShow()
    if (not svrt_cnfVariablesLoaded) then
        svrt_ConfigFrame:Hide();
        return;
    end
    getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonEnabledText"):SetText(svrt_CNF_ENABLED_TXT);
    getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonSoundText"):SetText(svrt_CNF_PLAY_SOUND_TXT);
    getglobal(svrt_ConfigFrame:GetName() .. "SliderSizeText"):SetText(svrt_CNF_SIZE_TXT);
    getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonEnabled"):SetChecked(svrt_cnf.enabled);
    getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonSound"):SetChecked(svrt_cnf.sound);
    getglobal(svrt_ConfigFrame:GetName() .. "SliderSize"):SetValue(svrt_cnf.size);
end

-- Notification of changes in the configuration
function svrt_cnfNotify()
    if (not svrt_cnfVariablesLoaded) then
        return;
    end
    svrt_cnf.enabled = getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonEnabled"):GetChecked();
    svrt_cnf.sound = getglobal(svrt_ConfigFrame:GetName() .. "CheckButtonSound"):GetChecked();
    svrt_cnf.size = getglobal(svrt_ConfigFrame:GetName() .. "SliderSize"):GetValue();
    svrt_updateIconCnf();
end
