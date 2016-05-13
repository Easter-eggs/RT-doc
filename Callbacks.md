# Callbacks

## Presentation

[RT Wiki Callbacks page](http://requesttracker.wikia.com/wiki/CustomizingWithCallbacks)
is a good reading for basic presentation, especially about Callbacks paths.

## Examples


We will attach a callback to be displayed at the top of a ticket's page, before ticket metadata.
The callback is defined in `share/html/Ticket/Display.html`, and is named `BeforeShowSummary`.

The file to create is `local/html/Callbacks/<whatever>/Ticket/Display.html/BeforeShowSummary` (where <whatever> is whatever you wants).

### Syntax

There's very few documentation around callbacks and syntax. It's important to note that RT is based on [Mason](http://www.masonhq.com/).

Interesting readings:
  * [Mason syntax doc](http://search.cpan.org/~jswartz/Mason-2.24/lib/Mason/Manual/Syntax.pod)
  * http://www.masonbook.com/book/chapter-2.mhtml

### Hello world

#### v1

  * Edit the `BeforeShowSummary` file to contain:

        Hello World

  * In RT, go to a ticket page, you should see "Hello World" at the top of the page

#### v2

Next step is to declare a variable and access it. We use the `<%init>` bloc:

    <%init>
    my $hello = "Hello World";
    </%init>

    <% $hello %>

This is equivalent to :

    % my $hello = "Hello World";
    <% $hello %>

### Accessing variables

#### Passed variables

In `share/html/Ticket/Display.html`, callbak call line is:

    % $m->callback( %ARGS, Ticket => $TicketObj, Transactions => $transactions, Attachments => $attachments, CallbackName => 'BeforeShowSummary');

In your callback file, you can access to variables passed by the caller:

  * $Ticket
  * $Transactions
  * $Attachments

($CallbackName is the only parameter that is not available in callback)

Example:

    <%args>
    $Ticket
    </%args>

    This page presents ticket number <% $Ticket->Id %>

#### Global variables

It's possible to access global variables in callback context.

##### Session

A Hash with an interesting key: CurrentUser with is a `RT::CurrentUser` object.

Example:

    $session{'CurrentUser'}->Name

Will return current user's name.
