# PHP-CGI Executable for AWS Lambda Artisan Host

Builds a PHP binary for use in a AWS Lambda

### Requirements
- Docker

### Run

```bash
sh ./buildphp.sh 7.2.0
```

You can pass any version of PHP you want. 

If you want to optimize the compile to use more jobs have a look in buildphp.sh. You can also change the build arguments, 
I want a good foundation for running default laravel. 



This package has taken inspiration from the following
- https://github.com/stechstudio/php-lambda
- https://github.com/araines/serverless-php
- https://github.com/ZeroSharp/serverless-php
