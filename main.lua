SimonCharacterMod = RegisterMod("Simon Character Mod", 1)

--#region characters
include("scripts.characters.simon")
--#endregion

--#region items
include("scripts.items.angelicrobes")
--#endregion

--#region modcompat
require("scripts.compat.eid")
--#endregion