# LSP vs ISP

Nick Hodges [is writing][coding in delphi group] a book "[More Coding in Delphi][more coding]" — a sequel to his excellent book "[Coding in Delphi][coding in delphi]". In a section about Interface Segregation Principle he uses essentially the same example as for Liskov Substitution Principle, only the names are changed. Here I'll try to show why I think that it is not a good idea and cannot explain the meaning of ISP to the readers. Worse, it can lead to an impression that both of these principles are very similar or even almost the same. If an example is the same and an outcome from applying the principles is the same, what's the difference, right? And, if one principle already fixes the problem, why bother to remember another one? I'll try to describe the difference, show what problems each of them is designed to prevent and take a closer look to the relation between LSP and ISP.

### The Liskov Substitution Principle

First, let's take a look at Liskov Substitution Principle and Nick's example for it.

A definition of LSP from [Uncle Bob's article][uncle bob LSP]:

>FUNCTIONS THAT USE POINTERS OR REFERENCES TO BASE CLASSES MUST BE ABLE TO USE OBJECTS OF DERIVED CLASSES WITHOUT KNOWING IT.

LSP deals with the situation when several classes are in the same class hierarchy or implement the same interface. They have an "**IS A**" relationship. It's all about polymorphism - all objects deriving from the same class or implementing the same interface should be substitutable for each other and the clients that use them through that base class or interface should not be concerned about the exact implementation.

Nick's example uses `IBird` interface and 2 implementing classes: `TCrow` and `TPenguin`.

    IBird = interface
      procedure Eat;
      procedure Fly;
    end;

    TCrow = class(TInterfacedObject, IBird);
    TPenguin = class(TInterfacedObject, IBird);

Here's a diagram for this code:

![Liskov Substitution Principle violation](http://yuml.me/c3310b60)

It would be good to add a client to this example, cause raising an exception or doing nothing in `TPenguin.Fly` is not inherently wrong, it violates LSP only **if** it breaks its clients — other objects who make calls to `IBird.Fly`.

Uncle Bob in his article writes:
>A model, viewed in isolation, can not be meaningfully validated. The validity of a model can only be expressed in terms of its clients.

Let's add one client for illustrative purposes:

    procedure TBirdKeeper.FeedAndReleaseBirds;
    var
      Bird: IBird;
    begin
      for Bird in AvailableBirds do
      begin
        Bird.Eat;
        Bird,Fly;
      end;
    end;

![Liskov Substitution Principle example with a client](http://yuml.me/044ab873)

Nick mentions several indications of LSP violations but doesn't really mention consequences and explain **why** it's bad.

##### What LSP violations do
They break polymorphism and force clients to add special handling for specific subtypes, thus coupling other parts of the system to them, making the system much more brittle and adding a lot to the maintenance burden.

If `TPenguin.Fly` would raise an exception, every call to it, including our `TBirdKeeper.FeedAndReleaseBirds`, would be broken.

##### LSP fix

Behaviorally `TPenguin` does not match `IBird` interface, so it cannot be in a "**is a**" relationship with `IBird`. To fix this, Nick divides `IBird` into 2 new interfaces: `IFlyable` and `IEater`. He also mentions that this solution uses the Interface Segregation Principle but I don't agree with that. It's true that ISP can be used to resolve LSP violations, but that's not the case in this example. But I'll talk more about it later.

![Liskov Substitution Principle fix](http://yuml.me/a84f2d45)

Now a programmer has to update `TBirdKeeper` to use these 2 interfaces instead of `IBird`, but it still will be decoupled from concrete classes. Also I'd like to point out that it's not **required** to break up `IBird` interface. If it would be really important to keep existing `TBirdKeeper` intact (our implementation depends on `IBird.Fly`, so there's no way it would be able to use `TPenguin` anyway), the problem could be resolved in a different way:

![Liskov Substitution Principle alternate fix](http://yuml.me/f3650171)

Any other clients, like `TFeeder` presented here, who were interested only in `IBird.Eat`, could now be updated to use `IEater.Eat` instead.

So, Nick's example could be improved, but is adequate for LSP. Unfortunately, he presents essentially the same example for ISP.

### The Interface Segregation Principle

A definition of ISP from another [Uncle Bob's article][uncle bob ISP]:

>CLIENTS SHOULD NOT BE FORCED TO DEPEND UPON INTERFACES THAT THEY DO NOT USE.

ISP deals with the situation when several clients talk to the same class through a "fat", non-cohesive interface, but each one uses only a part of all methods available.

![Interface Segregation Principle violation](http://yuml.me/47dc81ed)

##### What ISP violations do

They indirectly couple otherwise completely independent classes, thus forcing recompilation and redistribution of modules.

![Interface Segregation Principle fix](http://yuml.me/ffb5a3d7)

#### More resources

[Clean Code Episode 11, The Liskov Substitution Principle](https://cleancoders.com/episode/clean-code-episode-11-p1/show)

[Clean Code Episode 12, The Interface Segregation Principle](https://cleancoders.com/episode/clean-code-episode-12/show)

[Encapsulation and SOLID](http://www.pluralsight.com/courses/encapsulation-solid)

[coding in delphi group]: https://plus.google.com/u/0/communities/110978417023349293804
[more coding]: https://leanpub.com/morecodingindelphi
[coding in delphi]: https://leanpub.com/codingindelphi
[uncle bob LSP]: http://www.objectmentor.com/resources/articles/lsp.pdf
[uncle bob ISP]: http://www.objectmentor.com/resources/articles/isp.pdf
[role interface]: http://martinfowler.com/bliki/RoleInterface.html
