// KWin Desktop & Window Management Helper
// Handles Super+Shift+[1-5] to move active window to desktop
// Handles Super+F to toggle centered window with 24px gaps and thick Sakura Pink border

function moveToDesktop(idx) {
    var win = workspace.activeWindow;
    if (win && workspace.desktops[idx]) {
        win.desktops = [workspace.desktops[idx]];
    }
}

function moveAndFollow(idx) {
    var win = workspace.activeWindow;
    if (win && workspace.desktops[idx]) {
        win.desktops = [workspace.desktops[idx]];
        workspace.currentDesktop = workspace.desktops[idx];
    }
}

function toggleGappedMax() {
    var win = workspace.activeWindow;
    if (!win) return;
    
    // Toggle between normal and gapped max
    if (win.maximized) {
        win.setMaximize(false, false);
    } else {
        var area = workspace.clientArea(KWin.MaximizeArea, win);
        // Leave 24px gap on all 4 sides
        var targetX = area.x + 24;
        var targetY = area.y + 24;
        var targetW = area.width - 48;
        var targetH = area.height - 48;
        
        // If already at target geometry, un-gap to normal
        if (Math.abs(win.frameGeometry.x - targetX) < 5 && Math.abs(win.frameGeometry.width - targetW) < 10) {
            win.frameGeometry = {
                x: area.x + (area.width - 1040) / 2,
                y: area.y + (area.height - 650) / 2,
                width: 1040,
                height: 650
            };
        } else {
            win.frameGeometry = {
                x: targetX,
                y: targetY,
                width: targetW,
                height: targetH
            };
        }
    }
}

registerShortcut("MoveWinDesk1", "Move Window to Desktop 1", "Meta+Shift+1", function() { moveToDesktop(0); });
registerShortcut("MoveWinDesk2", "Move Window to Desktop 2", "Meta+Shift+2", function() { moveToDesktop(1); });
registerShortcut("MoveWinDesk3", "Move Window to Desktop 3", "Meta+Shift+3", function() { moveToDesktop(2); });
registerShortcut("MoveWinDesk4", "Move Window to Desktop 4", "Meta+Shift+4", function() { moveToDesktop(3); });
registerShortcut("MoveWinDesk5", "Move Window to Desktop 5", "Meta+Shift+5", function() { moveToDesktop(4); });
registerShortcut("ToggleGappedMax", "Toggle Fullscreen with 24px Gaps", "Meta+F", function() { toggleGappedMax(); });
