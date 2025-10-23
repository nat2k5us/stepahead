#!/bin/bash
# Apply default navbar configuration for template testing

sed -i '' 's/{{NAV_TAB_1_ID}}/home/g' index.html
sed -i '' 's/{{NAV_TAB_1_ICON}}/🏠/g' index.html
sed -i '' 's/{{NAV_TAB_1_LABEL}}/Home/g' index.html

sed -i '' 's/{{NAV_TAB_2_ID}}/explore/g' index.html
sed -i '' 's/{{NAV_TAB_2_ICON}}/🔍/g' index.html
sed -i '' 's/{{NAV_TAB_2_LABEL}}/Explore/g' index.html

sed -i '' 's/{{NAV_TAB_3_ID}}/favorites/g' index.html
sed -i '' 's/{{NAV_TAB_3_ICON}}/⭐/g' index.html
sed -i '' 's/{{NAV_TAB_3_LABEL}}/Favorites/g' index.html

sed -i '' 's/{{NAV_TAB_4_ID}}/profile/g' index.html
sed -i '' 's/{{NAV_TAB_4_ICON}}/👤/g' index.html
sed -i '' 's/{{NAV_TAB_4_LABEL}}/Profile/g' index.html

echo "✅ Applied default navbar configuration"
