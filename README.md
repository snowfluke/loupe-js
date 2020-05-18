# Loupe

An image magnifier for JavaScript. Based on this [Codepen](https://codepen.io/pixelacorn/pen/eNObea).

It supports mouse and touch events, and it can be used with React.

[__Demo__](https://nishanths.github.io/loupe-js/)

(A loupe is a small magnification device.)

<a href="https://nishanths.github.io/loupe-js">
	<img src="https://i.ibb.co/hRkZ1X2/Screen-Shot-2020-05-17-at-6-46-48-PM.png" alt="Screen-Shot-2020-05-17-at-6-46-48-PM" border="0">
</a>

## Install

Use npm or yarn

```
npm i --save loupe-js
```

```
yarn add loupe-js
```

If you want to evaluate the package quickly without using a package manager
use `dist/index.browser.js`, which has the module's exports in `window.loupe`.

## Example

Import "loupe-js" and the related CSS file.

```typescript
import { Loupe, enableLoupe } from "loupe-js"
import "loupe-js/dist/style.css"

const img = document.querySelector("img")!

const options = {
	magnification: 2,
	width: 250,
	height: 250,
	additionalClassName: "customLoupeClass",
	style: { boxShadow: "4px 5px 5px 4px rgba(0,0,0,0.5)" },
	shape: "circle",
}
const loupe = new Loupe(options) // or just `new Loupe()` to use default options

enableLoupe(img, img.src, loupe)
```

## React Example

For a function component using hooks:

```typescript
import { Loupe, enableLoupe } from "loupe-js"
import "loupe-js/dist/style.css"
import React, { useEffect } from "react"

export const MyPicture: React.SFC<{ imgUrl: string }> = ({ imgUrl }) => {
  const pictureRef = useRef<HTMLDivElement | undefined>(undefined)

  useEffect(() => {
    if (pictureRef.current !== undefined) {
      // create a loupe, and add it to the target element
      const loupe = new Loupe()
      const disable = enableLoupe(pictureRef.current, imgUrl, loupe)

      // on the way out, disable the loupe on the target element, and
      // remove it from the DOM
      return () => {
        disable()
        loupe.unmount()
      }
    }
  }, [pictureRef, imgUrl])

  return <div className="pic" ref={r => { pictureRef.current = r }}></div>
}
```

For a class component put the code in `componentDidMount()` and `componentWillUnmount()` instead.


## Documentation

### enableLoupe

`enableLoupe()` adds the specified `Loupe` object to the `target` element.

```typescript
const disable = enableLoupe(target, imgUrl, loupe)
```

The target element can be, for instance, an `<img>` element or a `<div>` element with a
background-image. The `imgUrl` is the URL to the image. For example, it is the src property
for an `<img>` element, or background-image CSS property for a `<div>` element.

The type definition is:

```typescript
(target: HTMLElement, imgUrl: string, loupe: Loupe) => (() => void)
```

`enableLoupe()` returns a cleanup function that can be used to disable the loupe
on the target element at a later time.

### Loupe

The `Loupe` constructor constructs a loupe object.

```typescript
const loupe = new Loupe(options)
```

Pass in a optional `LoupeOptions` object to the constructor to customize the loupe.

```typescript
type LoupeOptions = {
	magnification?: number // magnification level
	width?: number | string // width of the loupe
	height?: number | string // height of the loupe
	container?: Node // containing node
	additionalClassName?: string // additional class name to add to the loupe element
	style?: Partial<CSSStyleDeclaration> // additional styles to add to the loupe element
	shape?: "rectangle" | "circle" // shape of the loupe
}
```

All propeties are optional. By default the loupe element is placed at the end of `document.body`.
If the `shape` is `circle` you should use the same values for `width` and `height`.
The `additionalClassName` and `style` properties are useful to add custom styles
to the loupe element.

The default `LoupeOptions` values are

```typescript
{
	magnification: 2.25,
	width: 250,
	height: 250 / 1.6,
	container: document.body,
	additionalClassName: undefined,
	style: undefined,
	shape: "rectangle",
}
```

The `Loupe#unmount()` method removes the loupe element from the `container` node
in the DOM. The loupe object should not be used after.

```
loupe.unmount() // loupe element will longer exist in the DOM
```

## Recommendations

Using a `box-shadow` on the loupe helps separate the loupe nicely from your image.
For example:
```typescript
new Loupe({
	style: { boxShadow: "4px 5px 5px 4px rgba(0,0,0,0.5)" },
})
```

## License

BSD 2-Clause
