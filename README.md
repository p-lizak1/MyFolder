# MyFolderDemoApp

### Developer notes:

I have been using UIKit for the past 7 years. Have touched SwiftUI a few times, but the target was mostly iOS 13, and many things felt broken.
It was working more againts me then helping.
Looking into your app feels that it's using 100% SwiftUI, and also it's advised in the asssesment to use it in the demo project. So I took the chance and I loved it.


Implementing everything to detail requries a lot's of time, so I took a few notes what could be done better:
- Proper error handling, we capture many error types in the networking layer, but we don’t communicate this to the user
- The storage is not conforming to an interface, it should use a protocol
- Introduce caching.
- Introduce fast loading, meaning that if we have alredy the folder content(we were already in the folder and navigated back), we show it, but at the same time we fetch the folder content from the server. In case they don't match we update.
- After successful login, ideally the session ID should be stored in the KeyChain or any other secure place. In the demo app, we use the username, password credentials to identify the session.
- Don't use force unwrap, but given the timeframe it was more convenient
- After a failure, the user won’t have an option to re-try
- During the implementation I fell a bit into the rabit hole, wanted to use the [.photoPicker](https://developer.apple.com/documentation/swiftui/view/photospicker(ispresented:selection:matching:preferreditemencoding:)), but unfortunatelly it has a bug described [here](https://stackoverflow.com/questions/73520684/stateobject-doesnt-deinit-when-photospicker-was-presented)
- Using hard coded strings is not a good practice, won’t allow localisation and hard to maintain.
- Had some trouble to decode the modificationDate, it’s returned in different formats. It can be done, but it would require some undesired checks in the networking layer.
- I see many tutorials not injecting the ViewModel into the SwiftUI View. I am just wondering how to snapshot test those views ?
- More animations would be nice
- When having a good internet connection the loading is flickery, it's too fast. There is room for optimisation 
- Maybe a bit more test's, now the coverage is 38%. 
