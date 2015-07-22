#Setup

**Setup** is my final project with The Iron Yard.  It was made with a team of four people, consisting of:

*Jamie Gamblin* :: Front End website, concept  
*Trevor Terris* :: Ruby on Rails server   
*Tucker Watts* :: Ruby on Rails server  
*Kyle Robinson* :: iOS App

**Concept**

Setup is a dating application based around two main concepts:

####Profile Creation:

Unlike other dating websites where you make your own profile, Setup is based around the concept of making profiles for your friends.  You can't make your own profile; you need a friend to make it for you, making the search for a date more social and friend-inclusive than before.

####Video-Based:

Setup does include some text-based information for the purposes of searching (name, location, age, etc.) but it is primarily based around taking videos.  This gives it a unique take on the idea of a dating website, and makes profile creation particularly well-suited to the iPhone, where creating and uploading videos is straightforward and convenient.

#The iOS App

#####Technology Includes:
UIKit, Amazon S3 Networking, AVFoundation, camera functionality, video functionality, custom Ruby on Rails RESTful API.

Original envisioned as a simple extension of the website designed to take videos for the service, my iOS app grew into a full-blown mobile version of the web experience.  

With the iOS version of Setup, you can create and edit profiles for your friends, record and upload photo and videos, and search for profiles, as well as view your own profile (if you have one.)

Although this is a small app, I tried to think like a developer and take into consideration not only an MVC model, but also the best way that I might handle information as if I were making a much larger app for a corporation that anticipated thousands of users.

One example of this is how I dealt with video uploads.  I used Amazon S3 to store all of my videos and images.  Because storage space can quickly get very expensive when working with a large number of users, I wanted to make sure that no videos are actually saved until the *user confirms that they want them to be saved*.  The videos are only uploaded to S3 after **the link to where the video will be saved** is sent to the Rails server, and I've received a successful response.  This results in an efficient saving process that cuts down on excess videos and unnecessary waste.

The mobile app also makes frequent use of asynchronous requests to send and receive data, in order for it to run more efficiently and offer a smooth user experience.