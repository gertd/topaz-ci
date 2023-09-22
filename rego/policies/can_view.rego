package roblox.can_view_feedback

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
            "name": "can_view_feedback",
        },
        "object": {
            "key": resource.key,
            "type": "feedback"
        }
    })
}

# management chain can view if feedback is submitted
allowed {
    # load feedback object
    feedback := ds.object({
        "type": "feedback",
        "key": resource.key
    })

    # ensure the feedback has been published
    publishedStatuses := ["Submitted", "Completed"] 
    feedback.properties.status == publishedStatuses[_]

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
