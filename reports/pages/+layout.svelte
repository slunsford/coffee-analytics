<script>
  import '@evidence-dev/tailwind/fonts.css';
  import '../app.css';
  import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
  export let data;
</script>

<EvidenceDefaultLayout {data}
  title="lunsford.coffee"
  hideBreadcrumbs=false
  builtWithEvidence=true
  githubRepo="https://github.com/slunsford/coffee-analytics"
>
  <slot slot="content" />
</EvidenceDefaultLayout>
