

#let iwidth = 1.8em
#let H(path, left: 0em, right: 0em) = box(align(center)[#image(path)], width: iwidth, height: iwidth, stroke: black + 0.2pt, baseline: 0.6em, inset: (top: 0.1em, left: left, right: right))


#let map = (
  "1": ($2/2$, false, true),
  "2": ($2$, false, false),
  "3": ($24/8$, false, true),
  "4": ($4$, false, false),
  "5": ($4+2/2$, true, true),
  "6": ($24/4$, false, true),
  "7": ($8-2/2$, true, true),
  "8": ($8$, false, false),
  "9": ($8+2/2$, true, true),
  "0": ($2-2$, true, true),
  "24": ($24$, false, false),
  "12": ($24/2$, false, true)
)

#let expand(map, func, op) = {
  let pairs = map.pairs()
  for (ka, va) in pairs {
    for (kb, vb) in pairs {
      if ka != kb {
        let (a, na, ea) = va
        let (b, nb, eb) = vb
        let pa = if na { "(pa)" } else { "pa" }
        let pb = if nb { "(pb)" } else { "pb" }
        let key = str(func(int(ka), int(kb)))
        if map.at(key, default: none) == none {
          map.insert(key, (eval(pa + op + pb, mode: "math", scope: (pa: a, pb: b)), true, true))
        }
      }
    }
  }
  map
}

#{
  map = expand(map, (a, b) => a * b, " times ")
}

#let find(x) = {
  if map.at(str(x), default: none) != none {
    return map.at(str(x))
  }
  let h = calc.floor(calc.sqrt(x))
  if x - h * h == 0 {
    let (a, na, ea) = find(h)
    let pa = if na or ea { "(pa)" } else { "pa" }
    (eval(pa + "^2", mode: "math", scope: (pa: a)), true, true)
  } else {
    let (a, na, ea) = find(h)
    let (b, nb, eb) = find(x - h * h)
    let pa = if na or ea { "(pa)" } else { "pa" }
    (eval(pa + "^2 + pb", mode: "math", scope: (pa: a, pb: b)), true, true)
  }
}

#let kobe_numbers(body) = {
  show "2": H("kobe/2t.png", right: 0.5em)
  show "4": H("kobe/4t.png", left: 0.5em)
  show "24": H("kobe/24t.png")
  show "8": H("kobe/8t.png")
  show par: set block(spacing: 3em)
  show regex("-{0,1}\d+"): it => {
    if it.text.at(0) == "-" {
      let (a, na, ea) = find(int(it.text.slice(1)))
      if na {
        box(eval("-(pa)", mode: "math", scope: (pa: a)))
      } else {
        box("-" + a)
      }
    } else {
      box(find(int(it.text)).at(0))
    }
  }
  body
}