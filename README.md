# On_power

This simple script checks if the notebook is connected to electricity.

Exits with 0 if it is and 1 if it isn't.

Support multiple batteries (at least one have to be connected to electricity for success).

It can be used for demanding programs to not be run on battery and save the power of the battery.

## Usage

```
./on_power && do_some_action_required_eletricity
./on_power || do_some_action_on_battery
```
