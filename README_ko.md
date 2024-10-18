<img src="https://user-images.githubusercontent.com/3011832/154659440-d206a01e-a6bd-47a0-8428-5357799816de.png" alt="SwiftLayout Logo" height="180" />

*Yesterday never dies*

**A swifty way to use UIKit**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dswift-versions)](https://github.com/ioskrew/SwiftLayout)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fioskrew%2FSwiftLayout%2Fbadge%3Ftype%3Dplatforms)](https://github.com/ioskrew/SwiftLayout)

```swift
@LayoutBuilder var layout: some Layout {
  self.sl.sublayout {
    leftParenthesis.sl.anchors {
      Anchors.leading.equalToSuper(constant: 16)
      Anchors.centerY
    }
    viewLogo.sl.anchors {
      Anchors.leading.equalTo(leftParenthesis, attribute: .trailing, constant: 20)
      Anchors.centerY.equalToSuper(constant: 30)
      Anchors.size.equalTo(width: 200, height: 200)
    }
    UIImageView().sl.identifying("plus").sl.onActivate { imageView in
      imageView.image = UIImage(systemName: "plus")
      imageView.tintColor = .SLColor
    }.anchors {
      Anchors.center.equalToSuper(yOffset: 30)
      Anchors.size.equalTo(width: 150, height: 150)
    }
    constraintLogo.sl.anchors {
      Anchors.trailing.equalTo(rightParenthesis.leadingAnchor)
      Anchors.centerY.equalTo("plus")
      Anchors.size.equalTo(width: 200, height: 150)
    }
    rightParenthesis.sl.anchors {
      Anchors.trailing.equalToSuper(constant: -16)
      Anchors.centerY
    }
  }
}
```

# 요구조건

- iOS 13+

  | Swift version  | SwiftLayout version                                          |
  | -------------- | ------------------------------------------------------------ |
  | **Swift 6.0+** | **4.0.0**                                                    |
  | Swift 5.7      | [2.8.0](https://github.com/ioskrew/SwiftLayout/releases/tag/2.8.0) |
  | Swift 5.5      | [2.7.0](https://github.com/ioskrew/SwiftLayout/releases/tag/2.7.0) |

# 설치

**SwiftLayout**은 현재 **SPM(Swift Package Manager)**만 지원합니다.

```swift
dependencies: [
  .package(url: "https://github.com/ioskrew/SwiftLayout", from: "4.0.0"),
],
```

# 주요기능

- `addSubview` 와 `removeFromSuperview`를 대체하는 DSL이 제공됩니다
- `NSLayoutConstraint`, `NSLayoutAnchor` 를 대체하는 DSL이 제공됩니다.
- view와 constraint에 대한 선택적 갱신이 가능합니다.
- `if else`, `swift case`, `for` 등 조건문, 반복문을 통한 view, constraint 설정이 가능합니다.
- 값의 변경을 통한 layout 갱신을 자동으로 할 수 있게 도와주는 propertyWrapper를 제공합니다.
- constraint의 연결을 돕는 다양한 API 제공합니다.

# 사용법

> **Warning**
> **Swift6**로 업데이트되면서 **SwiftLayout**의 대부분의 인터페이스는 이제 **@MainActor** 에서 작동하도록 명시적으로 표시되어 있습니다.

### 용어

- **상위뷰** - UIView에서 superview
- **하위뷰** - UIView에서 subview

## LayoutBuilder

`LayoutBuilder`는 UIView 계층을 설정을 위한 DSL 빌더입니다. 이를 통해 간단하고 가시적인 방법으로 상위뷰에 하위뷰를 추가할 수 있습니다.

```swift
@LayoutBuilder var layout: some Layout {
  view.sl.sublayout {
    subview.sl.sublayout {
      subsubview
      subsub2view
    }
  }
}
```

위의 코드는 아래의 코드와 동일한 역할을 수행합니다.

```swift
view.addSubview(subview)
subview.addSubview(subsubview)
subview.addSubview(subsub2view)
```

## AnchorsBuilder

`AnchorsBuilder`는 뷰 간의 autolayout constraint의 생성을 돕는 `Anchors` 타입에 대한 DSL 빌더입니다.  
Layout의 메소드인 `anchors` 안에서 주로 사용됩니다.

### Anchors

`Anchors`는 NSLayoutConstraint를 생성할 수 있으며, 해당 제약조건에 필요한 여러 속성값을 가질 수 있습니다.

> NSLayoutConstraint 요약
> 
> - first: Item1 and attribute1
> - second: item2 and attribute2
> - relation: relation(=, >=, <=), constant, multiplier

> 제약 조건은 다음의 표현 식으로 나타낼 수 있습니다.  
> Item1.attribute1 [= | >= | <= ] multiplier x item2.attribute2 + constant

> NSLayoutConstraint에 대한 상세한 정보는 [여기](https://developer.apple.com/documentation/uikit/nslayoutconstraint)에서 확인하실 수 있습니다.

- Anchors에 정의된 static values를 사용하여 필요한 속성을 가져오는 것으로 시작합니다.
  
  ```swift
  Anchors.top.bottom
  ```

- equalTo와 같은 관계 메소드를 통해서 두번째 아이템(NSLayoutConstraint.secondItem, secondAttribute)을 설정할 수 있습니다.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.top.equalTo(superview, attribute: .top, constant: 10)
    }
  }
  ```
  
  생성된 `Anchors`는 다음과 같은 표현식으로 나타낼 수 있습니다.
  
  ```
  selfview.top = superview.top + 10
  ```

- 관계 메소드를 생략할 경우 두번째 아이템은 자동으로 해당 뷰의 상위뷰로 설정됩니다.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.sl.top.bottom
    }
  }
  ```
  
  이는 다음과 같은 표현 식으로 나타낼 수 있습니다.
  
  ```
  selfview.top = superview.top
  selfview.bottom = superview.bottom
  ...
  ```
  
  또한, 추가적으로 multiplier를 다음과 같이 설정할 수 있습니다.
  
  ```swift
  Anchors.top.multiplier(10)
  ```

- 너비와 높이는 두번째 아이템을 설정하지 않을 경우 자기 자신이 됩니다.
  
  ```swift
  superview.sl.sublayout {
    selfview.sl.anchors {
      Anchors.width.height.equalTo(constant: 10) // only for selfview
    }
  }
  ```
  
  이는 다음과 같은 표현 식을 나타냅니다.
  
  ```
  selfview.width = 10
  selfview.height = 10
  ```

## LayoutBuilder + AnchorsBuilder

### *드디어, 함께*

이제 `LayoutBuilder`와 `AnchorsBuilder`를 함께 사용하여 하위 뷰를 추가하고, 오토레이아웃을 생성해서 뷰에 적용할 수 있습니다.

- `anchors` 메소드를 호출한 후에 하위뷰를 추가하기 위해서는 `sublayout` 메소드가 필요합니다.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.allSides
      }.sublayout {
        subview.sl.anchors {
          Anchors.allSides
        }
      }
    } 
  }
  ```

- 혹시 계층구조가 너무 복잡한가요? 나눠쓰면 됩니다.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.allSides
      }
    }
    selfview.sl.sublayout {
      subview.sl.anchors {
        Anchors.allSides
      }
    }
  }
  ```

### active and finalActive

`LayoutBuilder`, `AnchorsBuilder` 로 만들어진 `Layout` 타입들은 실제 작업을 하기 위한 정보를 가지고 있을 뿐입니다.  
addSubview와 constraint의 적용을 위해서는 아래의 메소드를 호출해야 합니다.

- 동적인 화면 갱신을 사용하지 않는 경우, `Layout` 프로토콜의 `finalActive` 메소드를 호출해서 즉시 뷰 계층과 제약조건을 활성화할 수 있습니다.

- `finalActive`은 addSubview와 오토레이아웃의 활성화 작업을 끝낸 후 아무것도 반환하지 않습니다.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        Anchors.top
      }
    }
  }
  
  init() {
    layout().finalActive()
  }
  ```

- 화면 갱신과 관련한 여러 기능이 필요할 경우 `Layout` 프로토콜의 `active` 메소드를 호출할 수 있습니다.  
  갱신에 필요한 정보를 담고있는 객체인 `Activation`을 반환합니다.
  
  ```swift
  @LayoutBuilder func layout() -> some Layout {
    superview.sl.sublayout {
      selfview.sl.anchors {
        if someCondition {
          Anchors.bottom
        } else {
          Anchors.top
        }
      }
    }
  }
  
  var activation: Activation
  
  init() {
    activation = layout().active()
  }
  
  func someUpdate() {
    activation = layout().update(fromActivation: activation)
  }
  ```

### Layoutable

**SwiftLayout**에서 `Layoutable` 은 **SwiftUI**의 `View`가 하는 역할과 비슷한 역할을 일부 담당하고 있습니다.

`Layoutable`을 구현하려면 다음과 같이 코드를 구현해야합니다.

- `var activation: Activation?`

- `@LayoutBuilder var layout: some Layout { ... }`: @LayoutBuilder는 필수는 아니며, 최상위 레이아웃이 하나를 넘는 경우에 필요합니다.
  
  ```swift
  class SomeView: UIView, Layoutable {
    var activation: Activation?
    @LayoutBuilder var layout: some Layout {
      self.sl.sublayout {
        ...
      }
    }
  
    init(frame: CGRect) {
      super.init(frame: frame)
      self.sl.updateLayout() // call active or update of Layout
    }
  }
  ```

### LayoutProperty

SwiftLayout의 빌더들은 DSL을 구현하며, 그 덕에 사용자는 if, switch case 등을 구현할 수 있습니다.

다만, 상태 변화를 view의 레이아웃에 반영하기 위해서는 필요한 시점에 `Layoutable`에서 제공하는 `sl`프로퍼티의 `updateLayout`메소드를 직접 호출해야 합니다.

```swift
var showMiddleName: Bool = false {
  didSet {
    self.sl.updateLayout()
  }
}

var layout: some Layout {
  self.sl.sublayout {
    firstNameLabel
    if showMiddleName {
      middleNameLabel
    }
    lastNameLabel
  }
}
```

만약 `showMiddleName` 이 false인 경우, `middleNameLabel`은 상위뷰에 추가되지 않고, 이미 추가된 상태라면 상위뷰로부터 제거됩니다.

이런 상황에서 `LayoutProperty`를 사용하면 직접 updateLayout을 호출하지 않고 해당 값의 변경에 따라 자동으로 호출하게 됩니다.

```swift
@LayoutProperty var showMiddleName: Bool = false // change value call updateLayout of Layoutable

var layout: some Layout {
  self.sl.sublayout {
    firstNameLabel
    if showMiddleName {
      middleNameLabel
    }
    lastNameLabel
  }
}
```

### Animations

`Layoutable`의 오토레이아웃을 변경한 경우 애니메이션을 시작할 수 있습니다. 방법은 다음과 같이 간단합니다.

- `UIView`의 animation 블럭 안에서 `updateLayout` 을 `forceLayout` 매개변수를 true로 호출해주세요.

```swift
final class PreviewView: UIView, Layoutable {
  var capTop = true {
    didSet {
      // start animation for change constraints
      UIView.animate(withDuration: 1.0) {
        self.sl.updateLayout(forceLayout: true)
      }
    }
  }
  // or just use the convenient propertyWrapper like below
  // @AnimatableLayoutProperty(duration: 1.0) var capTop = true
  
  let capButton = UIButton()
  let shoeButton = UIButton()
  let titleLabel = UILabel()
  
  var topView: UIButton { capTop ? capButton : shoeButton }
  var bottomView: UIButton { capTop ? shoeButton : capButton }
  
  var activation: Activation?
  
  var layout: some Layout {
    self.sl.sublayout {
      topView.sl.anchors {
        Anchors.cap
      }
      bottomView.sl.anchors {
        Anchors.top.equalTo(topView.bottomAnchor)
        Anchors.height.equalTo(topView)
        Anchors.shoe
      }
      titleLabel.sl.onActivate { label in
        label.text = "Top Title"
        UIView.transition(with: label, duration: 1.0, options: [.beginFromCurrentState, .transitionCrossDissolve]) {
          label.textColor = self.capTop ? .black : .yellow
        }
      }.anchors {
        Anchors.center.equalTo(topView)
      }
      UILabel().sl.onActivate { label in
        label.text = "Bottom Title"
        label.textColor = self.capTop ? .yellow : .black
      }.identifying("title.bottom").anchors {
        Anchors.center.equalTo(bottomView)
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initViews()
  }
  
  func initViews() {
    capButton.backgroundColor = .yellow
    shoeButton.backgroundColor = .black
    capButton.addAction(.init(handler: { [weak self] _ in
      self?.capTop.toggle()
    }), for: .touchUpInside)
    shoeButton.addAction(.init(handler: { [weak self] _ in
      self?.capTop.toggle()
    }), for: .touchUpInside)
    self.sl.updateLayout()
  }
}
```

[![animation in update layout](https://user-images.githubusercontent.com/3011832/189062670-93b3bcef-fdea-458b-b18f-f37cce1ec8ee.png)](https://user-images.githubusercontent.com/3011832/189063286-f106ae90-fea1-464a-a798-3586109dac2f.mp4)

## 그 밖의 유용한 기능들

### UIView의 `onActivate(_:)`

Layout안에서 뷰의 속성을 설정할 수 있습니다.
onActivate 함수에 전달된 클로저는 활성화 프로세스 중에 호출됩니다.

```swift
contentView.sl.sublayout {
  nameLabel.sl.onActivate { label in 
    label.text = "Hello"
    label.textColor = .black
  }.anchors {
    Anchors.allSides
  }
}
```

### `UIView` 와 `Layout`의 `identifying`

`accessibilityIdentifier`을 설정하고 view reference 대신 해당 문자열을 이용할 수 있습니다.

```swift
contentView.sl.sublayout {
  nameLabel.sl.identifying("name").sl.anchors {
    Anchors.cap
  }
  ageLabel.sl.anchors {
    Anchors.top.equalTo("name", attribute: .bottom)
    Anchors.shoe
  }
}
```

- 디버깅의 관점에서 보면 identifying을 설정한 경우 NSLayoutConstraint의 description에 해당 문자열이 함께 출력됩니다.

### SwiftUI에서 사용하기

`UIView` 혹은, `UIViewController`에서 `Layoutable`을 구현한 경우 `SwiftUI`에서도 쉽게 사용이 가능합니다.

```swift
class ViewUIView: UIView, Layoutable {
  var layout: some Layout { 
    ...
  }
}

...

struct SomeView: View {
  var body: some View {
    VStack {
      ...
	    ViewUIView().sl.swiftUI
      ...
    }
  }
}

struct ViewUIView_Previews: PreviewProvider {
  static var previews: some Previews {
    ViewUIView().sl.swiftUI
  }
}
```



### SwiftLayoutUtil

#### LayoutPrinter

개발하는 과정에서 조건문이나 반복문 등의 사용으로 LayoutBuilder로 구성된 Layout이 원하는 바와 같은지 확인할 필요 때 유용하게 사용할 수 있는 유틸리티 객체입니다.

- Layout의 계층과 anchors로 작성된 트리를 출력해줍니다.
  
  ```swift
  var layout: some Layout {
    root.sl.sublayout {
      child.sl.anchors {
        Anchors.top
        Anchors.leading.trailing
      }
      friend.sl.anchors {
        Anchors.top.equalTo(child, attribute: .bottom)
        Anchors.bottom
        Anchors.leading.trailing
      }
    }
  }
  ```

- LayoutPrinter는 소스 안에서는 물론 디버그 콘솔에서 사용할 수 있습니다.
  
  > (lldb)  po import SwiftLayoutUtil; LayoutPrinter(layout).print()
  
  ```
  ViewLayout - view: root
  └─ TupleLayout
     ├─ ViewLayout - view: child
     └─ ViewLayout - view: friend
  ```

- 필요하다면 layout에 적용된 Anchors도 함께 출력할 수 있습니다.
  
  > (lldb)  po import SwiftLayoutUtil; LayoutPrinter(layout, withAnchors: true).print()
  
  ```
  ViewLayout - view: root
  └─ TupleLayout
     ├─ ViewLayout - view: child
     │        .top == superview.top
     │        .leading == superview.leading
     │        .trailing == superview.trailing
     └─ ViewLayout - view: friend
              .top == child.bottom
              .bottom == superview.bottom
              .leading == superview.leading
              .trailing == superview.trailing
  ```

#### ViewPrinter

xib혹은 UIKit으로 직접 구현되어 있는 뷰를 SwiftLayout으로 마이그레이션 할 때 유용하게 사용할 수 있는 유틸리티 객체입니다.

- UIView의 계층과 오토레이아웃 관계를 SwiftLayout의 문법으로 출력해줍니다.
  
  ```swift
  let contentView: UIView
  let firstNameLabel: UILabel
  contentView.addSubview(firstNameLabel)
  ```

- ViewPrinter는 소스 안에서는 물론 디버그 콘솔에서 사용할 수 있습니다.
  
  > (lldb) po import SwiftLayoutUtil; ViewPrinter(contentView).print()
  
  ```swift
  // 별도의 identifiying 설정이 없는 경우 주소값:View타입의 형태로 뷰를 표시합니다.
  0x01234567890:UIView { // contentView
    0x01234567891:UILabel // firstNameLabel
  }
  ```

- 다음과 같은 매개변수 설정을 통해 view의 label를 쉽게 출력할 수 있습니다.
  
  ```swift
  class SomeView {
    let root: UIView // subview of SomeView
    let child: UIView // subview of root
    let friend: UIView // subview of root
  }
  let someView = SomeView()
  ```
  
  > (lldb) po import SwiftLayoutUtil; ViewPrinter(someView, tags: [someView: "SomeView"]).updateIdentifiers().print()
  
  ```swift
  SomeView {
    root.sl.sublayout {
      child.sl.anchors {
        Anchors.top
        Anchors.leading.trailing
      }
      friend.sl.anchors {
        Anchors.top.equalTo(child, attribute: .bottom)
        Anchors.bottom
        Anchors.leading.trailing
      }
    }
  }
  ```

# Credits

- oozoofrog([@oozoofrog](https://twitter.com/oozoofrog))
- gmlwhdtjd([@gmlwhdtjd](https://github.com/gmlwhdtjd))
- della-padula([@della-padula](https://github.com/della-padula))
