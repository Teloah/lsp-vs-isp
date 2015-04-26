# LSP vs ISP

Nick Hodges [is writing][coding in delphi group] a book "[More Coding in Delphi][more coding]" - a sequel to his excellent book "[Coding in Delphi][coding in delphi]". In a section about Interface Segregation Principle he uses essentially the same example as for Liskov Substitution Principle, only the names are changed. Here I'll try to show why I think that it is not a good idea and cannot explain the meaning of ISP to the readers. Worse, it can lead to an impression that both of these principles are very similar or even almost the same. If an example is the same and an outcome from applying the principles is the same, what's the difference, right? And, if one principle already fixes the problem, why bother to remember another one? I'll try to explain the difference and show what problems each of them is designed to prevent.

**Note**: Nick disabled access to the chapter about SOLID principles, and I don't remember them completely, so my examples may differ from his in some details.

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

Here's a UML diagram for this code:

![Liskov Substitution Principle violation](http://yuml.me/c3310b60)

Even though a real penguin **is a** bird, there's nothing meaningful a programmer can write in `TPenguin.Fly`. There are only 2 options: do nothing or raise an exception, for example `ENotSupportedException`. But what's wrong with that if no one is making a call to `TPenguin.Fly`? Uncle Bob in his article writes:
>A model, viewed in isolation, can not be meaningfully validated. The validity of a model can only be expressed in terms of its clients.

To really feel the pain from a LSP violation, we need at least one client making calls to `IBird` methods. Sadly, Nick's example does not show any (at least I don't remember), so let's invent one.

    procedure TBirdLauncher.LaunchBird;
    var
      lBird : IBird;
    begin
      lBird := FBirdProvider.GetCurrentBird;
      lBird.Fly;
    end;

Now our model looks like this:
![Liskov Subsitition Principle violation 2](http://yuml.me/61332511)

`TBirdLauncher` does not know which implementation of `IBird` it will receive from `FBirdProvider`. It doesn't need to know and doesn't care as long as `lBird.Fly` behaves normally. But when a new version of `GetCurrentBird` starts to return instances of `TPenguin`, our `LaunchBird` blows up with a `ENotSupportedException`. What the programmer will do in this situation? He will add a check to prevent penguins from flying:

    lBird := FBirdProvider.GetCurrentBird;
    if not (lBird is TPenguin) then
      lBird.Fly;

If several classes make calls to `IBird.Fly`, this check (or at least `try..except` block) has to be added in each one of them. And it may not fix all problems if there are other parts of the system, which are expecting actions usually performed by `TCrow.Fly`. Those actions will not be performed and our system will be broken.

##### What LSP violations do
They break polymorphism and force programmers to add checks for specific subtypes, thus coupling other parts of the system to them.

##### LSP fix

To fix this LSP violation we need to acknowledge that behaviorally `TPenguin` is not a `IBird`, so it cannot be in a "**is a**" relationship with `IBird`. 

![Liskov Substitution Principle fix](http://yuml.me/814fb230)

So, Nick's example is adequate for LSP. Unfortunately, he presents essentially the same example for ISP.

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

[coding in delphi group]: https://plus.google.com/u/0/communities/110978417023349293804
[more coding]: https://leanpub.com/morecodingindelphi
[coding in delphi]: https://leanpub.com/codingindelphi
[uncle bob LSP]: http://www.objectmentor.com/resources/articles/lsp.pdf
[uncle bob ISP]: http://www.objectmentor.com/resources/articles/isp.pdf
[role interface]: http://martinfowler.com/bliki/RoleInterface.html