const LicensePage = () => {
  return (
    <main className="mx-auto max-w-3xl px-6 py-16">
      <h1 className="text-3xl font-semibold text-text-primary">Open Source Notice</h1>
      <div className="mt-6 space-y-4 text-sm leading-6 text-text-secondary">
        <p>This internal deployment includes open-source software and related third-party components.</p>
        <p>Use of this deployment remains subject to the applicable open-source licenses distributed with the source code and dependency packages.</p>
        <p>If you need the full license materials for audit or compliance review, contact your system administrator.</p>
      </div>
    </main>
  )
}

export default LicensePage
