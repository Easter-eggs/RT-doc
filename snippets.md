# Loading objects

More snippets are available on [official wiki](https://rt-wiki.bestpractical.com/index.php?title=CodeSnippets).

**Important**: All snippets here must begin with this the init code described in [general.md](general.md) file.

## Load a Queue

```perl
my $queue = RT::Queue->new(RT->SystemUser);
$queue->Load('My Queue Name');
p $queue;
```

## Load a Custom field

```perl
my $cf1 = RT::CustomField->new(RT->SystemUser);
$cf1->LoadByName(Name => 'cf1');
```

## List tickets in a queue

```perl
my $queueName = 'My Queue';
my $tickets = RT::Tickets->new(RT->SystemUser);  # RT::Tickets instance
$tickets->LimitQueue(VALUE => $queueName);
print $tickets->Count . " tickets founds in queue '" . $queueName . "':\n";
while (my $ticket = $tickets->Next()) {
    # $ticket is an RT::Ticket instance
    print "   - #" . $ticket->Id . ": " . $ticket->Subject . "\n";
}
```
