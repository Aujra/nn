local unitViewer = {}
tt.UI.UnitViewer = unitViewer

print("UnitViewer loaded")

local viewerFrame = nil
local searchTable = nil
local fake_cols = {
    {
        ["name"] = "GUID",
        ["width"] = 100,
        ["align"] = "CENTER",
        ["colorargs"] = nil,
        ["defaultsort"] = "dsc"
    },
    {
        ["name"] = "Name",
        ["width"] = 350,
        ["align"] = "CENTER",
        ["colorargs"] = nil,
        ["defaultsort"] = "dsc"
    },
    {
        ["name"] = "Level",
        ["width"] = 350,
        ["align"] = "CENTER",
        ["colorargs"] = nil,
        ["defaultsort"] = "dsc"
    },
    {
        ["name"] = "Distance",
        ["width"] = 350,
        ["align"] = "CENTER",
        ["colorargs"] = nil,
        ["defaultsort"] = "dsc"
    }
}
local data = {}

function unitViewer:UpdateUnits()
    data = {
        "a","b","c","d"
    }
    if not viewerFrame then
        viewerFrame = tt.nn.Utils.AceGUI:Create("Frame")
        viewerFrame:SetTitle("Unit Viewer")
        viewerFrame:SetLayout("Fill")
        viewerFrame:SetWidth(800)
        viewerFrame:SetHeight(600)
        viewerFrame:Show()
    end
    if not searchTable then
        searchTable = tt.nn.Utils.AceGUI:Create("SearchTable", fake_cols)
        viewerFrame:AddChild(searchTable)
    end
    searchTable.scrollInstance:SetData(data, true)
end