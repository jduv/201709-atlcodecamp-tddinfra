# TDDing Infrastructure

**Challenge**: Building infrastructure is hard, and managing changes difficult because any modifications you make will be applied in production without the ability to test.

TDD is a methodology used in developing software that places emphasis on testing software before building production code. This allows us to ensure that the behaviours of our software are paramount as opposed to the  code. There are three ways to handle testing infrastructure:

    1. Eyeball it.
    2. Test everything in a staging environment
    3. Write tests!

This repo as some examples of TDD in the obvious directory, and it has the corresponding terraform for making those tests pass. Additionally, there's a very small trivial inspec example.

In order to run these examples it is assumed that you are utilizing the AWS_PROFILE variable approach to configuring the AWS SDK. Otherwise, you're on your own with respect to getting it working. Feel free to email questions to me, or file an issue here. Slides are also checked in.