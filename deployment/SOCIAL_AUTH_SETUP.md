# Social Authentication Setup Guide

This guide explains how to configure social login providers (Google, Facebook, Twitter, LinkedIn) for your Speech Therapy app.

## Prerequisites

- Firebase project already created (`speechtherapy-fa851`)
- Access to Firebase Console: https://console.firebase.google.com

## Step 1: Enable Authentication Providers in Firebase

1. Go to **Firebase Console** → Select your project
2. Navigate to **Authentication** → **Sign-in method** tab
3. Enable each provider you want to use:

### Google Sign-In
1. Click **Google** → **Enable** toggle
2. Set **Project support email** (your email)
3. Click **Save**
4. ✅ **Google is ready to use!** (No additional OAuth setup needed)

### Facebook Sign-In
1. Create a Facebook App at https://developers.facebook.com
2. Add **Facebook Login** product to your app
3. Copy **App ID** and **App Secret**
4. In Firebase Console, click **Facebook** → **Enable**
5. Paste **App ID** and **App Secret**
6. Copy the **OAuth redirect URI** from Firebase
7. In Facebook App Settings → Facebook Login → Settings:
   - Add the OAuth redirect URI to **Valid OAuth Redirect URIs**
8. Click **Save** in Firebase Console
9. ✅ **Facebook is configured!**

### Twitter Sign-In
1. Create a Twitter App at https://developer.twitter.com/en/portal/dashboard
2. In your Twitter App:
   - Enable **OAuth 2.0** authentication
   - Set **Type of App** to "Web App, Automated App or Bot"
   - Add **Callback URI** from Firebase Console
3. Copy **API Key** and **API Secret**
4. In Firebase Console, click **Twitter** → **Enable**
5. Paste **API Key** and **API Secret**
6. Click **Save**
7. ✅ **Twitter is configured!**

### LinkedIn Sign-In
1. Create a LinkedIn App at https://www.linkedin.com/developers/apps
2. In your LinkedIn App:
   - Go to **Auth** tab
   - Add **OAuth 2.0 Redirect URLs** (copy from Firebase Console)
   - Request **OpenID Connect** scopes: `openid`, `profile`, `email`
3. Copy **Client ID** and **Client Secret**
4. In Firebase Console:
   - You'll need to use the **OAuthProvider** configuration
   - The provider ID is `oidc.linkedin`
   - This is already configured in the code
5. ✅ **LinkedIn is configured!**

## Step 2: Add Authorized Domains

In Firebase Console → **Authentication** → **Settings** → **Authorized domains**:

Add these domains:
- `localhost` (for local testing in browser)
- Your production web domain (e.g., `yourapp.com`)

**CRITICAL for iOS Capacitor:**
- Firebase Auth OAuth doesn't work directly in Capacitor/WKWebView
- The redirect URL uses a custom scheme that Firebase can't handle
- **Workaround**: Use a web-based authentication flow:
  1. Open OAuth in Safari (external browser)
  2. Redirect back to app using custom URL scheme
  3. Handle the auth token in the app

**iOS Authentication Flow:**
The app is configured to automatically detect iOS and use **redirect-based authentication** instead of popups. When a user clicks a social login button on iOS:
1. User is redirected to the provider's OAuth page (Google, Facebook, etc.)
2. After authentication, they're redirected back to the app
3. The app captures the auth result and signs the user in

**Note:** For production iOS apps, you'll need to handle deep linking properly in your Capacitor configuration.

## Step 3: Test Each Provider

1. Open your app in a browser
2. Click each social login button
3. Verify the OAuth flow works correctly
4. Check that user data is saved properly

## iOS-Specific Considerations

### Popup vs Redirect
The code automatically handles this:
- Tries **popup** first (better UX)
- Falls back to **redirect** if popup is blocked (works in iOS WKWebView)

### Universal Links (for production iOS app)
For production deployment, you may need to:
1. Configure **Associated Domains** in your iOS app
2. Add **Universal Links** in Firebase Console
3. Update your app's **entitlements**

## Troubleshooting

### "This domain is not authorized"
- Add your domain to Firebase → Authentication → Settings → Authorized domains

### "This sign-in method is not enabled"
- Enable the provider in Firebase Console → Authentication → Sign-in method

### "Popup blocked"
- The app will automatically fallback to redirect method
- Or allow popups for your domain

### "Account exists with different credential"
- User previously signed in with a different provider using the same email
- Link accounts or use the original sign-in method

## Security Best Practices

1. **Never commit OAuth secrets** to version control
2. Use **environment variables** for sensitive keys in production
3. Configure **OAuth consent screens** properly
4. Limit **scopes** to only what you need
5. Keep **Firebase SDK** up to date

## Testing in Development

For local testing:
1. Use `http://localhost:5500` (or your dev server port)
2. Add `localhost` to Firebase authorized domains
3. Test each provider individually

## Production Deployment

Before deploying to production:
1. ✅ All providers enabled in Firebase Console
2. ✅ Production domain added to authorized domains
3. ✅ OAuth apps configured with production URLs
4. ✅ SSL/HTTPS enabled on your domain
5. ✅ Privacy policy and terms of service links added

## Support

For issues with:
- **Firebase Auth**: https://firebase.google.com/support
- **Google OAuth**: https://developers.google.com/identity
- **Facebook Login**: https://developers.facebook.com/support
- **Twitter API**: https://developer.twitter.com/en/support
- **LinkedIn OAuth**: https://www.linkedin.com/developers

---

**Last Updated**: 2024
**Firebase SDK Version**: 10.14.0
