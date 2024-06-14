local u = import '../path-utils/main.libsonnet';
local m = u.matchers;

{
  prometheusAlerts: {
    groups: [
      {
        name: 'group1',
        rules: [
          {
            alert: 'alert1',
            expr: 'vector(1)',
            labels: {
              severity: 'info',
            },
          },
          {
            alert: 'alert2',
            expr: 'vector(1)',
            labels: {
              severity: 'warning',
            },
          },
        ],
      },
      {
        name: 'group2',
        rules: [
          {
            alert: 'alert3',
            expr: 'vector(1)',
            labels: {
              severity: 'critical',
            },
          },
        ],
      },
    ],
  },
}
// Add env and runbook labels to all alerts in group1
+ u.withArrayItemAtPathMixin(
  'prometheusAlerts.groups',
  m.objectKeyValueInItem({ name: 'group1' }),
  u.withArrayItemAtPathMixin(
    'rules',
    m.allItems(),
    (
      u.withValueAtPathMixin('labels.env', 'prod')
      + u.withValueAtPathMixin('annotations.runbook', 'http://some/runbook')
    )
  )
)
// Override alert3's labels
+ u.withArrayItemAtPathMixin(
  'prometheusAlerts.groups',
  m.allItems(),
  u.withArrayItemAtPathMixin(
    'rules',
    m.objectKeyValueInItem({ alert: 'alert3' }),
    u.withValueAtPath('labels', { env: 'dev' })  // we need to use labels as the path and not labels.env since we wish to override labels
  )
)
