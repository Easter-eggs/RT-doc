# Callbacks

## Presentation

[RT Wiki Callbacks page](https://rt-wiki.bestpractical.com/index.php?title=CustomizingWithCallbacks)
is a good reading for basic presentation, especially about Callbacks paths.

## Examples


We will attach a callback to be displayed at the top of a ticket's page, before ticket metadata.
The callback is defined in `share/html/Ticket/Display.html`, and is named `BeforeShowSummary`.

The file to create is `local/html/Callbacks/[whatever]/Ticket/Display.html/BeforeShowSummary` (where *[whatever]* is whatever you wants).

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

Next step is to declare a variable and access it. We use the `<%INIT>` bloc:

    <%INIT>
    my $hello = "Hello World";
    </%INIT>

    <% $hello %>

This is equivalent to :

    % my $hello = "Hello World";
    <% $hello %>

### Accessing variables

#### Global variables

There are two global variables always accessible in views :
  * `$session`
  * `$DECODED_ARGS`

$session contains an interesting key: CurrentUser, which is a [`RT::User`](https://docs.bestpractical.com/rt/latest/RT/User.html) object.

Example:

    $session{'CurrentUser'}->Name

Will return current user's name.


#### Passed variables

In `share/html/Ticket/Display.html`, callbak call line is:

    % $m->callback( %ARGS, Ticket => $TicketObj, Transactions => $transactions, Attachments => $attachments, CallbackName => 'BeforeShowSummary');

In your callback file, you can access to variables passed by the caller:

  * $Ticket
  * $Transactions
  * $Attachments

($CallbackName is the only parameter that is not available in callback)

Example:

    <%ARGS>
    $Ticket
    </%ARGS>

    This page presents ticket number <% $Ticket->Id %>

### Adding code

**Trick**: no space before %

Example:

    <%ARGS>
    $User => undef;
    $Friendly => 0;
    </%ARGS>

    % if ($Name) {
    %     if ($Friendly) {
              Hello dear <% $Name %>, happy to see you here !
    %    } else {
              Hello <% $Name %>
    %    }
    % }

### Adding init block

Sometime it's usefull to compute some variables, or do some job before displaying anything.
That's why init block is for:

    % if ($can_modify) {
          <a href="/modify">Modify me</a>
    % }
    % if ($can_modify_cf) {
          <a href="/modify_cf">Modify custom fileds</a>
    % }

    <%ARGS>
    $User;
    $Ticket;
    </%ARGS>

    <%INIT>
    # Normal Perl code here
    my $can_modify = $Ticket->CurrentUserHasRight('ModifyTicket');
    my $can_modify_cf = $Ticket->CurrentUserHasRight('ModifyCustomField');
    <%/INIT>

(notice that args and init blocks can be placed anywhere in the file; order isn't important)

=> see also [debugging.md](debugging.md)
