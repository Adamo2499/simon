SimonCharacterMod = RegisterMod("Simon Character Mod", 1)

--#region characters
include("scripts.characters.simon")
--#endregion

--#region items
include("scripts.items.angelicrobes")
include("scripts.items.gospelofjohn")
include('scripts.items.sleepingbag')
include('scripts.items.barmbrack')
include("scripts.items.cooties")
include("scripts.items.bishopsrobes")
include("scripts.items.sippycap")
--#endregion

--#region modcompat
require("scripts.compat.eid")
--#endregion