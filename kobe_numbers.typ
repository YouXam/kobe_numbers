

#let iwidth = 1.8em
#let H(path) = box(image(path), width: iwidth, height: iwidth, stroke: black + 0.2pt, baseline: 0.6em)


#let map = (
  "1": ($2/2$, false),
  "2": ($2$, false),
  "3": ($4-2/2$, true),
  "4": ($4$, false),
  "5": ($4+2/2$, true),
  "6": ($2+4$, true),
  "7": ($2 times 4-2/2$, true),
  "8": ($8$, false),
  "9": ($2 times 4+2/2$, true),
  "0": ($2-2$, true),
  "24": ($24$, false),
)

#let find(x, pair: false) = {
  if map.at(str(x), default: none) != none {
    return map.at(str(x))
  }
  let h = calc.floor(calc.sqrt(x))
  if x - h * h == 0 {
    let (a, na) = find(h, pair: true)
    let pa = if na { "(pa)" } else { "pa" }
    (eval(pa + "^2", mode: "math", scope: (pa: a)), true)
  } else {
    let (a, na) = find(h, pair: true)
    let (b, nb) = find(x - h * h, pair: true)
    let pa = if na { "(pa)" } else { "pa" }
    let pb = if nb { "(pb)" } else { "pb" }
    (eval(pa + "^2 + " + pb, mode: "math", scope: (pa: a, pb: b)), true)
  }
}

#let kobe_numbers(body) = {
  show "2": H("kobe/2.png")
  show "4": H("kobe/4.png")
  show "24": H("kobe/24.png")
  show "8": H("kobe/8.png")
  show regex("\d+"): it => {
    set text(10pt)  
    box(find(int(it.text)).at(0))
  }
  body
}