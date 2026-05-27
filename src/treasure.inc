.ifndef TREASURE_SET_H
TREASURE_SET_H=1

.struct TreasureSet
    _tile_id_start .byte
    _tile_id_end .byte
    _set_size .byte ; treasures in this set
    _scores .res 12 ; 6 treasures max in set, each with 2 bytes for score value
    _set_score .word ; bonus score for collecting the whole set
    _collected .byte ; how many treasures collected in this set
.endstruct

.endif