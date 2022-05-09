;;in conventional programming: every time we add a new type, we must change all of the operation procedures, but if we add a new operation we don't need to change anything, we only need to add the new procedure



;;in message passing: every time we add a new type we don't need to change anything, we simply add the new type with all the associated operations...if we add a new operation though we need to change every single data procedure to add this new procedure


;;in data directed programming: we can add new operations AND new types without needing to change any code, we simply add new entries to the table




;;for a system where new types are often added, use message passing
;;for a system where new operations are often added, use conventional programming
