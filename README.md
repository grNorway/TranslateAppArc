# Translate App

Translate App is an app that allow the users to translate text. There are two ways to input text:

- Enter text for translation from keyboard
- Enter text from image

#### Languages

- Languages that are available on Google Translate API

#### Text detection from images

- For Detection (OCR) we are using MLKit from Firebase

### How to use it

App has a UITapBar with 2 input text options. 

- Text
- Camera

User can select the text input source. For text the user just add the text tothe from textField and but choosing the languages from and to he can translate. 
If the user want to add text from a camera he tap on camera icon, take a picture, and detect text.

There are 2 options for image detection
- Offline (on phone) <-- low accurate
- Online (cloud) <-- best accuracy 

After that he can select the languages he wants to add as from and to and translate.

The To textField if it get double tapped you can have a full screen translated text.

## How to setup the project

1) Create a project on Google console
2) Enable Google Cloud Translate API : https://cloud.google.com/translate/
3) Generate API Key and add it to code
4) Create a project on Firebase console
5) Enable MLKit : https://firebase.google.com/docs/ml-kit/
6) install pods

     pod 'Firebase/Core'
    pod 'Firebase/MLVision'
    pod 'Firebase/MLVisionTextModel'







