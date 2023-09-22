package roblox.can_admin

import input.user

# default to a "closed" system,
# only grant access when explicitly granted
default allowed = false

allowed {
    ds.check_relation({
        "subject": {
            "key": user.key,
            "type": "user"
        },
        "relation": {
            "object_type": "group",
            "name": "member"
        },
        "object": {
            "key": "rogro_admin",
            "type": "group"
        }
    })
}
