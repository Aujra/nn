local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local ScrollingTable = LibStub("ScrollingTable");

local unitViewer = {}
tt.UI.UnitViewer = unitViewer

print("UnitViewer loaded")

local viewerFrame = nil
local ScrollTable = nil
local searchTable = nil
local cols = {}
local data = {}

function tt:AddColumn(name)
    local column = {
        ["name"] = name,
        ["width"] = 100,
        ["align"] = "LEFT",
        ["color"] = {
            ["r"] = 1.0,
            ["g"] = 1.0,
            ["b"] = 1.0,
            ["a"] = 1.0
        },
        ["colorargs"] = nil,
        ["bgcolor"] = {
            ["r"] = 0.0,
            ["g"] = 0.0,
            ["b"] = 0.0,
            ["a"] = 1.0
        },
        ["DoCellUpdate"] = nil,
    }
    table.insert(cols, column)
end

function unitViewer:UpdateUnits()
    data = {}
    for k,v in pairs(tt.Units) do
        if v.pointer then
            local row = {
                v.Name,
                v.pointer,
                v:DistanceFromPlayer(),
            }
            table.insert(data, row)
        end
    end
    if not viewerFrame then
        viewerFrame = AceGUI:Create("Window", "ObjectViewerFrame", UIParent)
        viewerFrame:SetTitle("Unit Viewer")
        viewerFrame:SetLayout("Flow")
        viewerFrame:SetWidth(1024)
        viewerFrame:SetHeight(600)
        viewerFrame:Show()
    end

    tt:AddColumn("Name")
    tt:AddColumn("Pointer")
    tt:AddColumn("Distance")

    if not ScrollTable then
        ScrollTable = ScrollingTable:CreateST(cols, nil, nil, nil, viewerFrame.frame);
    end
    ScrollTable:SetData(data, true)
end