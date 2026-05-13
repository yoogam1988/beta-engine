type HelpPageProps = {
  params: Promise<{
    slug?: string[]
  }>
}

const HelpPage = async ({ params }: HelpPageProps) => {
  const { slug = [] } = await params
  const topic = slug.length > 0 ? slug.join(' / ') : 'overview'

  return (
    <main className="mx-auto max-w-3xl px-6 py-16">
      <h1 className="text-3xl font-semibold text-text-primary">Help Center</h1>
      <div className="mt-6 space-y-4 text-sm leading-6 text-text-secondary">
        <p>This deployment uses an internal help entry instead of the public upstream documentation site.</p>
        <p>Requested topic: <span className="font-medium text-text-primary">{topic}</span></p>
        <p>If this topic needs internal documentation, please ask your administrator or product owner to add a team-specific guide.</p>
      </div>
    </main>
  )
}

export default HelpPage
