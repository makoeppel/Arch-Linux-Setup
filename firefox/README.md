- clone https://github.com/Aris-t2/CustomCSSforFx into .mozilla
- about:support > Profile Folder > Open Folder find default-release folder (for example myovwijs)
- copy prefs.js into .mozilla/firefox/myovwijs.default-release
- make folder chrome in .mozilla/firefox/myovwijs.default-release
- copy CustomCSSforFx/current into chrome folder
- change file userChrome.css to use multi lines
@import "./css/tabs/tabs_below_navigation_toolbar_alt.css";
- change in the about:config (Browser tab)
toolkit.legacyUserProfileCustomizations.stylesheets > true || enables custom style sheets
browser.compactmode.show > true || shows ‘Compact mode’ in customizing mode
browser.uidensity > 1 || enables compact mode
browser.proton.enabled > true || enables proton mode
browser.proton.contextmenus.enabled || enables proton context menus
browser.proton.doorhangers.enabled > true
browser.proton.modals.enabled > true
browser.proton.places-tooltip.enabled > true
