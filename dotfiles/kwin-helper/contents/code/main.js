// KWin Desktop & Window Management Helper
// Move active window with Super+Shift+[1-5]
// Toggle 24px-gapped fullscreen with Super+F

function moveToDesktop(idx) {
    var win = workspace.activeWindow;
    if (!win) return;
    if (workspace.desktops && idx >= 0 && idx < workspace.desktops.length) {
        win.desktops = [workspace.desktops[idx]];
    }
}

function toggleGappedMax() {
    var win = workspace.activeWindow;
    if (!win) return;
    
    if (win.maximized) {
        win.setMaximize(false, false);
    }
    
    var screen = workspace.activeScreen;
    var area = workspace.clientArea(KWin.MaximizeArea, win);
    var targetX = area.x + 24;
    var targetY = area.y + 24;
    var targetW = area.width - 48;
    var targetH = area.height - 48;
    
    if (Math.abs(win.frameGeometry.x - targetX) < 8 && Math.abs(win.frameGeometry.width - targetW) < 16) {
        // Restore to centered float
        win.frameGeometry = {
            x: area.x + Math.round((area.width - 1100) / 2),
            y: area.y + Math.round((area.height - 700) / 2),
            width: 1100,
            height: 700
        };
    } else {
        // Expand to 24px-gapped fullscreen
        win.frameGeometry = {
            x: targetX,
            y: targetY,
            width: targetW,
            height: targetH
        };
    }
}

// Shortcuts for moving active window to desktops 1-5
registerShortcut("MoveWinDesk1", "Move Window to Desktop 1", "Meta+Shift+1", function() { moveToDesktop(0); });
registerShortcut("MoveWinDesk2", "Move Window to Desktop 2", "Meta+Shift+2", function() { moveToDesktop(1); });
registerShortcut("MoveWinDesk3", "Move Window to Desktop 3", "Meta+Shift+3", function() { moveToDesktop(2); });
registerShortcut("MoveWinDesk4", "Move Window to Desktop 4", "Meta+Shift+4", function() { moveToDesktop(3); });
registerShortcut("MoveWinDesk5", "Move Window to Desktop 5", "Meta+Shift+5", function() { moveToDesktop(4); });

// Toggle Fullscreen with 24px Gaps
registerShortcut("ToggleGappedMax", "Toggle Fullscreen with 24px Gaps", "Meta+F", function() { toggleGappedMax(); });
