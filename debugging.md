# Debugging techniques

To debug things, it's important to be able to look **inside** objects. The [Data::Printer](http://search.cpan.org/dist/Data-Printer/lib/Data/Printer.pm) module is perfect for that.
This module define two mains functions:

  - **p()**: do the action of prining out (with colors)
  - **np()**: return the string representing object

So doing `print np(@something)` is equivalant of doing `p(@something)`.

    use Data::Printer;  # Debug
    print '@my_var: '. np(@my_var) . "\n";

## print vs RT->Logger

TODO
```perl
RT->Logger->warning("Unable to loaf this user.");
```

### STDERR / STDOUT

Depending on context, prining to STDOUT - that is the default of *print* function (and *p* function) - have not the same effect as printing to STDERR.

Typically, when coding in views, printing to STDOUT add string to current HTML code.
To print in console logs, use STDERR outputs.

## Display all traces

=> be sure to copy the config sample given in [readme.md](readme.md)

It's possible to temporary enable all backtraces of all printed logs. This can be a hudge gain of time when you have an error message that is not very verbose.

```perl
# Show me all traces
Set($LogStackTraces, 'debug');
```

## Debugging in scrips

TODO

## Debugging in views

**Remember**: You must not any space in the beginning of lines

    <tr class="id">
        <td class="label"><&|/l&>Id</&>:</td>
        <td class="value"><%$Ticket->Id %></td>
    </tr>
    %# Debugging start here
    % use Data::Printer;
    % print STDERR '$Ticket: '. np($Ticket);

### Trying a post request many times

When working on a piece of code that happends when a post request is fired, it's usefull to be able to repost it many times.
This can be done with this piece of code that compiles but crash when executed:

    RT->boom;
