package roblox.can_edit

import input.user
import input.resource

# default to a "closed" system,
# only grant access when explicitly granted
default allowed = false

allowed {
    ds.check_permission({
        "subject": {
            "key": user.key,
            "type": "user"
        },
        "permission": {
            "name": "can_edit",
        },
        "object": {
            "key": resource.key,
            "type": "feedback"
        }
    })
}
