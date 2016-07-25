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
## Get a CF value for a ticket

```perl
my $ticket = RT::Ticket->new(RT->SystemUser);
$ticket->Load(12);  # Load by id
my $cf = $ticket->LoadCustomFieldByIdentifier('My CF name');  # RT::CustomField
my $vals = $ticket->CustomFieldValues($cf);  # RT::ObjectCustomFieldValues
# Print first selected value
if ($vals->First) {  # RT::ObjectCustomFieldValue
    p $vals->First->Content;  # String
} else {
    p undef;
}
```

## Set a CF value for a ticket

```perl
my $ticket = RT::Ticket->new(RT->SystemUser);
$ticket->Load(12);  # Load by id
$ticket->AddCustomFieldValue(Field => 'My CF name', Value => 'My value');
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
