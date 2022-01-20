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
    
    let result = view {
        yellow {
            green
        }
        red {
            blue
        }
    }.layout {
        if flag {
            yellow.dsl.top.to(view)
            yellow.dsl.bottom.to(view)
            yellow.dsl.leading.to(view)
            yellow.dsl.trailing.to(view)
        } else {
            red.dsl.top.bottom.leading.trailing.to(view)
        }
    }
```
