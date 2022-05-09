when serialized-exchanged is called it will create several unecessary serializers



first the serializer1, then serializer2, then it would (serializer1 (serializer2 exchange))

but exchange is a procedure which calls, among others, withdraw from account1 and deposit from account2....but the way Louis implemented, withdraw is already serialized and deposit is also already serialized

this would cause the code to stop, because we have the SAME serializer (say, S1) twice for withdraw and another serializer (say, S2) twice for deposit
