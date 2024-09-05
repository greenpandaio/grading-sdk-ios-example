### Cocoapods

#### Prerequisites

Install Cocoapods gem

#### Cocoapods private trunk setup

Add the private trunk repo to your local Cocoapods installation, using the command:

```
pod repo add {specs_trunk_name} {repo_url}
```

#### Adding the dependency

Create a new iOS project. Open the terminal and run `pod init` inside the path of the iOS Project.

Add the source of the private trunk repository in the Podfile file newly created.

```
source 'repo_url'
```

Add the pod and then run `pod install` inside the terminal

```
pod PandasGradingSDK
```

**Sample**

A Podfile integrating the PandasGradingSDK should look like this

```
platform :ios, '12.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/greenpandaio/grading-sdk-ios-podspec.git'

target 'PandasExample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'PandasGradingSDK'

  target 'PandasExampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PandasExampleUITests' do
    # Pods for testing
  end

end
```