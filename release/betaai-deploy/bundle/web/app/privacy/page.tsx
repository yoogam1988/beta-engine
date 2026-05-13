const PrivacyPage = () => {
  return (
    <main className="mx-auto max-w-3xl px-6 py-16">
      <h1 className="text-3xl font-semibold text-text-primary">Privacy Policy</h1>
      <div className="mt-6 space-y-4 text-sm leading-6 text-text-secondary">
        <p>AtomFlow is deployed for internal use. Access, prompts, files, and generated content may be processed for operational, security, and auditing purposes within your organization.</p>
        <p>Only authorized administrators and approved services should access workspace data. Do not upload regulated or highly sensitive information unless your internal policy explicitly allows it.</p>
        <p>For questions about data retention, access control, or deletion, contact your system administrator.</p>
      </div>
    </main>
  )
}

export default PrivacyPage
