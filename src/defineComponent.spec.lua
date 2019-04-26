local defineComponent = require(script.Parent.defineComponent)

return function()
    it("should create component classes", function()
        expect(defineComponent("test", function() end)).to.be.ok()
    end)

    it("should create component classes with a name and creator", function()
        local component = defineComponent("Test", function() end)
        expect(typeof(component.className)).to.equal("string")
        expect(component.className).to.equal("Test")

        expect(typeof(component._create)).to.equal("function")
    end)

    it("should throw if given a non-string name", function()
        expect(function()
            defineComponent(123, function()
            end)
        end).to.throw()
    end)

    it("should throw if given a non-function generator", function()
        expect(function()
            defineComponent("test", true)
        end).to.throw()
    end)

    describe("_create", function()
        it("should create components", function()
            local class = defineComponent("test", function()
                return {
                    a = 1,
                    b = 2,
                }
            end)

            local component = class._create()
            expect(component.a).to.equal(1)
            expect(component.b).to.equal(2)
        end)

        it("should throw if the generator function does not return a table", function()
            local class = defineComponent("test", function()
                return 123456
            end)

            expect(class._create).to.throw()
        end)

        it("should set up the metatable properly", function()
            local class = defineComponent("test", function()
                return {
                    a = 1,
                    b = 2,
                }
            end)

            function class:setA(newA)
                self.a = newA
            end

            local component = class._create()
            expect(component.a).to.equal(1)
            component:setA(2)
            expect(component.a).to.equal(2)
        end)
    end)
end