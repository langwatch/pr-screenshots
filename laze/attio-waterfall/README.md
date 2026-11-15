# iOS sheet bar screenshots

BEFORE is `1f9343bf7817c87e35dbbaf3d4d0c57065686e63`; AFTER is `403e5e480`. Captures use iPhone 17 Pro on iOS 26 unless marked iPad. All captures use the Mac QA workspace. Each image is cropped to the screen header and nearby edge.

On iPhone sheets, the drawn bar moved from y=62 pt to y=78 pt, a 16 pt inset. The native toolbar sample also began at y=78 pt, 16 pt below the sheet edge. Full screen conversation and thread bars stayed at y=62 pt. The iPad sheet moved down 16 pt as well.

Builds succeeded for BEFORE and AFTER. LazeKit passed 1,045 XCTest cases plus 3 Swift Testing tests on AFTER; FeedTests passed 17/17. The decisions sheet UI test passed on retry after QA decisions were available.

The sampled bar rows have room below the sheet edge, centered titles, and aligned controls. Full screen bars did not gain a gap. Existing title collisions remain in the message reminder and schedule editor sheets on both revisions.

Vault key detail/edit/replace/reveal/share and agent access screenshots are omitted: the available captures showed a non-QA key fixture, and the later QA-only recapture stalled before reaching the home screen. Agent settings and sharing are also omitted because their fixtures display names that should not be published. Other data-dependent routes are omitted where the QA workspace had no matching data.

| Screen | BEFORE | AFTER |
| --- | --- | --- |
| add-agent-light | [before-add-agent-light.png](before-add-agent-light.png) | [after-add-agent-light.png](after-add-agent-light.png) |
| add-emoji-light | [before-add-emoji-light.png](before-add-emoji-light.png) | [after-add-emoji-light.png](after-add-emoji-light.png) |
| add-people-light | [before-add-people-light.png](before-add-people-light.png) | [after-add-people-light.png](after-add-people-light.png) |
| agent-profile-light | [before-agent-profile-light.png](before-agent-profile-light.png) | [after-agent-profile-light.png](after-agent-profile-light.png) |
| app-data-record-light | [before-app-data-record-light.png](before-app-data-record-light.png) | [after-app-data-record-light.png](after-app-data-record-light.png) |
| app-members-light | [before-app-members-light.png](before-app-members-light.png) | [after-app-members-light.png](after-app-members-light.png) |
| app-pin-picker-light | [before-app-pin-picker-light.png](before-app-pin-picker-light.png) | [after-app-pin-picker-light.png](after-app-pin-picker-light.png) |
| app-view-options-light | [before-app-view-options-light.png](before-app-view-options-light.png) | [after-app-view-options-light.png](after-app-view-options-light.png) |
| approval-deny-light | [before-approval-deny-light.png](before-approval-deny-light.png) | [after-approval-deny-light.png](after-approval-deny-light.png) |
| approvals-light | [before-approvals-light.png](before-approvals-light.png) | [after-approvals-light.png](after-approvals-light.png) |
| catch-up-light | [before-catch-up-light.png](before-catch-up-light.png) | [after-catch-up-light.png](after-catch-up-light.png) |
| channel-details-light | [before-channel-details-light.png](before-channel-details-light.png) | [after-channel-details-light.png](after-channel-details-light.png) |
| channel-settings-light | [before-channel-settings-light.png](before-channel-settings-light.png) | [after-channel-settings-light.png](after-channel-settings-light.png) |
| cli-key-recheck-light | [before-cli-key-recheck-light.png](before-cli-key-recheck-light.png) | [after-cli-key-recheck-light.png](after-cli-key-recheck-light.png) |
| cli-keys-light | [before-cli-keys-light.png](before-cli-keys-light.png) | [after-cli-keys-light.png](after-cli-keys-light.png) |
| composer-custom-send-light | [before-composer-custom-send-light.png](before-composer-custom-send-light.png) | [after-composer-custom-send-light.png](after-composer-custom-send-light.png) |
| conversation-light | [before-conversation-light.png](before-conversation-light.png) | [after-conversation-light.png](after-conversation-light.png) |
| create-workspace-light | [before-create-workspace-light.png](before-create-workspace-light.png) | [after-create-workspace-light.png](after-create-workspace-light.png) |
| devices-passkeys-light | [before-devices-passkeys-light.png](before-devices-passkeys-light.png) | [after-devices-passkeys-light.png](after-devices-passkeys-light.png) |
| edit-topic-light | [before-edit-topic-light.png](before-edit-topic-light.png) | [after-edit-topic-light.png](after-edit-topic-light.png) |
| external-invite-light | [before-external-invite-light.png](before-external-invite-light.png) | [after-external-invite-light.png](after-external-invite-light.png) |
| external-share-light | [before-external-share-light.png](before-external-share-light.png) | [after-external-share-light.png](after-external-share-light.png) |
| feed-comment-light | [before-feed-comment-light.png](before-feed-comment-light.png) | [after-feed-comment-light.png](after-feed-comment-light.png) |
| feed-custom-snooze-light | [before-feed-custom-snooze-light.png](before-feed-custom-snooze-light.png) | [after-feed-custom-snooze-light.png](after-feed-custom-snooze-light.png) |
| feed-edit-light | [before-feed-edit-light.png](before-feed-edit-light.png) | [after-feed-edit-light.png](after-feed-edit-light.png) |
| feed-pending-decisions-light | [before-feed-pending-decisions-light.png](before-feed-pending-decisions-light.png) | [after-feed-pending-decisions-light.png](after-feed-pending-decisions-light.png) |
| invite-people-light | [before-invite-people-light.png](before-invite-people-light.png) | [after-invite-people-light.png](after-invite-people-light.png) |
| ipad-needs-you-light | [before-ipad-needs-you-light.png](before-ipad-needs-you-light.png) | [after-ipad-needs-you-light.png](after-ipad-needs-you-light.png) |
| message-emoji-light | [before-message-emoji-light.png](before-message-emoji-light.png) | [after-message-emoji-light.png](after-message-emoji-light.png) |
| message-forward-light | [before-message-forward-light.png](before-message-forward-light.png) | [after-message-forward-light.png](after-message-forward-light.png) |
| message-menu-light | [before-message-menu-light.png](before-message-menu-light.png) | [after-message-menu-light.png](after-message-menu-light.png) |
| message-reminder-light | [before-message-reminder-light.png](before-message-reminder-light.png) | [after-message-reminder-light.png](after-message-reminder-light.png) |
| message-select-text-light | [before-message-select-text-light.png](before-message-select-text-light.png) | [after-message-select-text-light.png](after-message-select-text-light.png) |
| native-document-picker-light | [before-native-document-picker-light.png](before-native-document-picker-light.png) | [after-native-document-picker-light.png](after-native-document-picker-light.png) |
| native-photo-picker-light | [before-native-photo-picker-light.png](before-native-photo-picker-light.png) | [after-native-photo-picker-light.png](after-native-photo-picker-light.png) |
| native-toolbar-light | [before-native-toolbar-light.png](before-native-toolbar-light.png) | [after-native-toolbar-light.png](after-native-toolbar-light.png) |
| needs-you-dark | [before-needs-you-dark.png](before-needs-you-dark.png) | [after-needs-you-dark.png](after-needs-you-dark.png) |
| needs-you-light | [before-needs-you-light.png](before-needs-you-light.png) | [after-needs-you-light.png](after-needs-you-light.png) |
| new-app-light | [before-new-app-light.png](before-new-app-light.png) | [after-new-app-light.png](after-new-app-light.png) |
| new-channel-light | [before-new-channel-light.png](before-new-channel-light.png) | [after-new-channel-light.png](after-new-channel-light.png) |
| new-conversation-light | [before-new-conversation-light.png](before-new-conversation-light.png) | [after-new-conversation-light.png](after-new-conversation-light.png) |
| new-message-light | [before-new-message-light.png](before-new-message-light.png) | [after-new-message-light.png](after-new-message-light.png) |
| new-section-light | [before-new-section-light.png](before-new-section-light.png) | [after-new-section-light.png](after-new-section-light.png) |
| open-browser-light | [before-open-browser-light.png](before-open-browser-light.png) | [after-open-browser-light.png](after-open-browser-light.png) |
| operator-keys-dark | [before-operator-keys-dark.png](before-operator-keys-dark.png) | [after-operator-keys-dark.png](after-operator-keys-dark.png) |
| operator-keys-light | [before-operator-keys-light.png](before-operator-keys-light.png) | [after-operator-keys-light.png](after-operator-keys-light.png) |
| pause-notifications-light | [before-pause-notifications-light.png](before-pause-notifications-light.png) | [after-pause-notifications-light.png](after-pause-notifications-light.png) |
| person-profile-light | [before-person-profile-light.png](before-person-profile-light.png) | [after-person-profile-light.png](after-person-profile-light.png) |
| profile-light | [before-profile-light.png](before-profile-light.png) | [after-profile-light.png](after-profile-light.png) |
| reactors-light | [before-reactors-light.png](before-reactors-light.png) | [after-reactors-light.png](after-reactors-light.png) |
| schedule-editor-light | [before-schedule-editor-light.png](before-schedule-editor-light.png) | [after-schedule-editor-light.png](after-schedule-editor-light.png) |
| schedule-existing-editor-light | [before-schedule-existing-editor-light.png](before-schedule-existing-editor-light.png) | [after-schedule-existing-editor-light.png](after-schedule-existing-editor-light.png) |
| schedule-runs-light | [before-schedule-runs-light.png](before-schedule-runs-light.png) | [after-schedule-runs-light.png](after-schedule-runs-light.png) |
| search-light | [before-search-light.png](before-search-light.png) | [after-search-light.png](after-search-light.png) |
| status-light | [before-status-light.png](before-status-light.png) | [after-status-light.png](after-status-light.png) |
| thread-light | [before-thread-light.png](before-thread-light.png) | [after-thread-light.png](after-thread-light.png) |
| vault-add-light | [before-vault-add-light.png](before-vault-add-light.png) | [after-vault-add-light.png](after-vault-add-light.png) |
| vault-light | [before-vault-light.png](before-vault-light.png) | [after-vault-light.png](after-vault-light.png) |
| wiki-editor-light | [before-wiki-editor-light.png](before-wiki-editor-light.png) | [after-wiki-editor-light.png](after-wiki-editor-light.png) |
| you-light | [before-you-light.png](before-you-light.png) | [after-you-light.png](after-you-light.png) |
