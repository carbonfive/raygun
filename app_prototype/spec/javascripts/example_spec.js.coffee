# This is an example spec, delete when there are some real specs.

class Foo
  bar: ->
    false

class Bar
  foo: ->
    false


describe "Foo", ->
  it "it is not bar", ->
    v = new Foo()
    expect(v.bar()).toEqual(false)

describe "Bar", ->
  it "it is not foo", ->
    v = new Bar()
    expect(v.foo()).toEqual(false)
