# AutolayoutDSL
Autolayout DSL library

목표는 코드로 표현하는 인터페이스 빌더입니다.

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
