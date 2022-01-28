# SwiftLayout
view hierarchy and autolayout DSL library

# goal
뷰의 계층구조와 constraint 관계를 편리하고 보기 쉽게 설정할 수 있는 라이브러리를 목표로 하고 있습니다.

```swift
    let yellow = UIView()
    yellow.backgroundColor = .yellow
    
    let green = UIView()
    green.backgroundColor = .green
    
    let red = UIView()
    red.backgroundColor = .red
    
    let blue = UIView()
    blue.backgroundColor = .blue
    
    // view의 계층구조에서 별도의 constraint를 지정하지 않으면 
    // 항상 부모뷰의 top, bottom, leading, parent에 붙습니다.
    view {
        if flag {
            yellow {
                green
            }
        } else {
            red {
                blue
            }
        }
    }
```

## Principal

- 외부로 노출하는 API는 UIView에서 사용가능한것 외에 새로운 것을 사용하지 않는다.

