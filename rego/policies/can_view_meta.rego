package roblox.can_view_meta

import future.keywords.if
import future.keywords.in

import input.user
import input.resource

# default to a "closed" system,
# only grant access when explicitly granted
default allowed = false

# explicitly assigned permission
allowed {
    ds.check_permission({
        "subject": {
            "key": user.key,
            "type": "user"
        },
        "permission": {
            "name": "can_view_meta",
        },
        "object": {
            "key": resource.key,
            "type": "feedback"
        }
    })
}

# management chain can view meta
allowed {
    # load review subject associated with this feedback
    review_subject := ds.relation({
        "object": {
            "type": "feedback",
            "key": resource.key
        },
        "relation": {
            "object_type": "feedback",
            "name": "review_subject"
        },
        "subject": {
            "type": "user"
        }
    }).results[0].subject.key

    # ensure user is in the management chain of the review subject
    ds.check_relation({
        "subject": {
            "key": review_subject,
            "type": "user"
        },
        "relation": {
            "object_type": "user",
            "name": "manager"
        },
        "object": {
            "key": user.key,
            "type": "user"
        }
    })
}

# calibration security group
allowed {
    # load review subject associated with this feedback
    review_subject := ds.relation({
        "object": {
            "type": "feedback",
            "key": resource.key
        },
        "relation": {
            "object_type": "feedback",
            "name": "review_subject"
        },
        "subject": {
            "type": "user"
        }
    }).results[0].subject.key

    # get calibration security groups of which they are a member
    groups := ds.relations({
        "subject": {
            "key": review_subject,
            "type": "user"
        },
        "relation": {
            "name": "member"
        },
        "object": {
            "type": "calibration_security_group"
        }
    }).results

    # check user is a viewer in any of the groups
    any_match(user.key, groups)
}

any_match(user_key, groups) if {
    some g in groups
    check_viewer(user.key, g.object.key)
}

check_viewer(user_key, object_key) := result {
    result := ds.check_relation({
        "subject": {
            "key": user_key,
            "type": "user"
        },
        "relation": {
            "name": "viewer"
        },
        "object": {
            "key": object_key,
            "type": "calibration_security_group"
        }
    })
}

# admin
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

