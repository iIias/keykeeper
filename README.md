# keykeeper-mac

menubar password manager with style & asymmetric encryption by apple 🔑🔥

## Planned

1. Neural Network to predict which key you are most likely to use next and sort it in that order
2. Unlock your keychain with a physical device (like a flash-drive)
3. Remove unneccesarry memory leaks
4. Improve use of popover events and the way you close them

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Xcode 6.3 (or higher) & macOS 10.9 (or higher)
```

### Installing

Get the project folder on your system and open keykeeper.xcworkspace either via terminal or directly with Xcode (6.3++)
(Don't forget the Podfile 😉)

## Instruments

If interested you're welcome to work on memory leaks with the Xcode Developer Tool "Instruments"

1. Open Xcode
2. On the top left select Xcode > Developer Tools
3. Click on Instruments
4. Select 'Leaks'
5. Choose 'keykeeper' from the process lists
6. Click Choose to create a trace document
7. Click the Record button (🔴) in the toolbar (or press Command-R) to begin recording.
8. Use your app normally.

## Built With

* [kishikawa katsumi](https://github.com/kishikawakatsumi) - KeychainAccess framework used 🔥

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
