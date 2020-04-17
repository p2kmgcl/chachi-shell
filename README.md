# Chachi shell

Ansible playbook with roles to have a full configured environment.
Each role directory contains it's own configuration.

## gh-wrapper examples

```
git do-list-pull-requests
Lists prs from originUsername
```

```
git do-list-pull-requests liferay-echo
Lists prs from liferay-echo
```

```
git do-checkout-pull-request 123
Creates pr/originUsername/123
```

```
git do-checkout-pull-request liferay-echo 123
Creates pr/liferay-echo/123
```

```
Branch some-feature
git do-send-pull-request liferay-echo

Pushes some-feature to origin
Creates PR on liferay-echo
Adds ci:forward comment
Updates jira ticket
```

```
Branch pr/originUsername/124
git do-send-pull-request liferay-echo

Pushes pr/originUsername/124 to origin
Creates PR on person
Adds ci:forward comment
Adds /cc @personWhoCreated originUsername/124
Add link to new PR in originUsername/124
Closes originUsername/124
Updates jira ticket
```
