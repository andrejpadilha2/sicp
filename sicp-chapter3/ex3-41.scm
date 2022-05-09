It would not make a difference. The "balance" accessor simply returns the balance of the account.
If it is not serialized, it could be interleaved with a withdraw or deposit process, but it would still be fine, since it would return either the value BEFORE that process or AFTER it, since balance is changed only ONCE inside each process.
