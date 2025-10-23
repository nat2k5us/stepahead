// Bottom Navigation Bar Configuration
// Customize this file to define your app's navigation tabs
const NAVBAR_CONFIG = {
  tabs: [
    {
      id: 'home',
      icon: '📅',
      label: 'Days',
      default: true
    },
    {
      id: 'explore',
      icon: '📊',
      label: 'Progress',
      default: false
    },
    {
      id: 'favorites',
      icon: '⚙️',
      label: 'Settings',
      default: false
    },
    {
      id: 'profile',
      icon: '👤',
      label: 'Profile',
      default: false
    }
  ]
};

// Template placeholders for initialization script:
// {{NAV_TAB_1_ICON}}, {{NAV_TAB_1_LABEL}}, {{NAV_TAB_1_ID}}
// {{NAV_TAB_2_ICON}}, {{NAV_TAB_2_LABEL}}, {{NAV_TAB_2_ID}}
// {{NAV_TAB_3_ICON}}, {{NAV_TAB_3_LABEL}}, {{NAV_TAB_3_ID}}
// {{NAV_TAB_4_ICON}}, {{NAV_TAB_4_LABEL}}, {{NAV_TAB_4_ID}}
