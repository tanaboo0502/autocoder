/**
 * Spec Creation Chat Component
 *
 * Full chat interface for interactive spec creation with Claude.
 * Handles the 7-phase conversation flow for creating app specifications.
 */

import { useCallback, useEffect, useRef, useState } from 'react'
import { Send, X, CheckCircle2, AlertCircle, Wifi, WifiOff, RotateCcw, Loader2, ArrowRight, Zap, Paperclip, ExternalLink } from 'lucide-react'
import { useSpecChat } from '../hooks/useSpecChat'
import { ChatMessage } from './ChatMessage'
import { QuestionOptions } from './QuestionOptions'
import { TypingIndicator } from './TypingIndicator'
import type { ImageAttachment } from '../lib/types'

// Image upload validation constants
const MAX_FILE_SIZE = 5 * 1024 * 1024 // 5 MB
const ALLOWED_TYPES = ['image/jpeg', 'image/png']

type InitializerStatus = 'idle' | 'starting' | 'error'

interface SpecCreationChatProps {
  projectName: string
  onComplete: (specPath: string, yoloMode?: boolean) => void
  onCancel: () => void
  onExitToProject: () => void  // Exit to project without starting agent
  initializerStatus?: InitializerStatus
  initializerError?: string | null
  onRetryInitializer?: () => void
}

export function SpecCreationChat({
  projectName,
  onComplete,
  onCancel,
  onExitToProject,
  initializerStatus = 'idle',
  initializerError = null,
  onRetryInitializer,
}: SpecCreationChatProps) {
  const [input, setInput] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [yoloEnabled, setYoloEnabled] = useState(false)
  const [pendingAttachments, setPendingAttachments] = useState<ImageAttachment[]>([])
  const messagesEndRef = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)

  const {
    messages,
    isLoading,
    isComplete,
    connectionStatus,
    currentQuestions,
    start,
    sendMessage,
    sendAnswer,
    disconnect,
  } = useSpecChat({
    projectName,
    onComplete,
    onError: (err) => setError(err),
  })

  // Start the chat session when component mounts
  useEffect(() => {
    start()

    return () => {
      disconnect()
    }
  }, []) // eslint-disable-line react-hooks/exhaustive-deps

  // Scroll to bottom when messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, currentQuestions, isLoading])

  // Focus input when not loading and no questions
  useEffect(() => {
    if (!isLoading && !currentQuestions && inputRef.current) {
      inputRef.current.focus()
    }
  }, [isLoading, currentQuestions])

  const handleSendMessage = () => {
    const trimmed = input.trim()
    // Allow sending if there's text OR attachments
    if ((!trimmed && pendingAttachments.length === 0) || isLoading) return

    // Detect /exit command - exit to project without sending to Claude
    if (/^\s*\/exit\s*$/i.test(trimmed)) {
      setInput('')
      onExitToProject()
      return
    }

    sendMessage(trimmed, pendingAttachments.length > 0 ? pendingAttachments : undefined)
    setInput('')
    setPendingAttachments([]) // Clear attachments after sending
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    // IME入力中（日本語変換中）は送信しない
    if (e.key === 'Enter' && !e.shiftKey && !e.nativeEvent.isComposing) {
      e.preventDefault()
      handleSendMessage()
    }
  }

  const handleAnswerSubmit = (answers: Record<string, string | string[]>) => {
    sendAnswer(answers)
  }

  // File handling for image attachments
  const handleFileSelect = useCallback((files: FileList | null) => {
    if (!files) return

    Array.from(files).forEach((file) => {
      // Validate file type
      if (!ALLOWED_TYPES.includes(file.type)) {
        setError(`Invalid file type: ${file.name}. Only JPEG and PNG are supported.`)
        return
      }

      // Validate file size
      if (file.size > MAX_FILE_SIZE) {
        setError(`File too large: ${file.name}. Maximum size is 5 MB.`)
        return
      }

      // Read and convert to base64
      const reader = new FileReader()
      reader.onload = (e) => {
        const dataUrl = e.target?.result as string
        // dataUrl is "data:image/png;base64,XXXXXX"
        const base64Data = dataUrl.split(',')[1]

        const attachment: ImageAttachment = {
          id: `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`,
          filename: file.name,
          mimeType: file.type as 'image/jpeg' | 'image/png',
          base64Data,
          previewUrl: dataUrl,
          size: file.size,
        }

        setPendingAttachments((prev) => [...prev, attachment])
      }
      reader.readAsDataURL(file)
    })
  }, [])

  const handleRemoveAttachment = useCallback((id: string) => {
    setPendingAttachments((prev) => prev.filter((a) => a.id !== id))
  }, [])

  const handleDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault()
      handleFileSelect(e.dataTransfer.files)
    },
    [handleFileSelect]
  )

  const handleDragOver = useCallback((e: React.DragEvent) => {
    e.preventDefault()
  }, [])

  // Connection status indicator
  const ConnectionIndicator = () => {
    switch (connectionStatus) {
      case 'connected':
        return (
          <span className="flex items-center gap-1 text-xs text-[var(--color-neo-done)]">
            <Wifi size={12} />
            接続中
          </span>
        )
      case 'connecting':
        return (
          <span className="flex items-center gap-1 text-xs text-[var(--color-neo-pending)]">
            <Wifi size={12} className="animate-pulse" />
            接続中...
          </span>
        )
      case 'error':
        return (
          <span className="flex items-center gap-1 text-xs text-[var(--color-neo-danger)]">
            <WifiOff size={12} />
            エラー
          </span>
        )
      default:
        return (
          <span className="flex items-center gap-1 text-xs text-[var(--color-neo-text-secondary)]">
            <WifiOff size={12} />
            切断
          </span>
        )
    }
  }

  return (
    <div className="flex flex-col h-full bg-[var(--color-neo-bg)]">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b-3 border-[var(--color-neo-border)] bg-white">
        <div className="flex items-center gap-3">
          <h2 className="font-display font-bold text-lg text-[#1a1a1a]">
            仕様作成: {projectName}
          </h2>
          <ConnectionIndicator />
        </div>

        <div className="flex items-center gap-2">
          {isComplete && (
            <span className="flex items-center gap-1 text-sm text-[var(--color-neo-done)] font-bold">
              <CheckCircle2 size={16} />
              完了
            </span>
          )}

          {/* Exit to Project - always visible escape hatch */}
          <button
            onClick={onExitToProject}
            className="neo-btn neo-btn-ghost text-sm py-2"
            title="チャットを終了してプロジェクトへ移動（エージェントは手動で開始できます）"
          >
            <ExternalLink size={16} />
            プロジェクトへ
          </button>

          <button
            onClick={onCancel}
            className="neo-btn neo-btn-ghost p-2"
            title="Cancel"
          >
            <X size={20} />
          </button>
        </div>
      </div>

      {/* Error banner */}
      {error && (
        <div className="flex items-center gap-2 p-3 bg-[var(--color-neo-danger)] text-white border-b-3 border-[var(--color-neo-border)]">
          <AlertCircle size={16} />
          <span className="flex-1 text-sm">{error}</span>
          <button
            onClick={() => setError(null)}
            className="p-1 hover:bg-white/20 rounded"
          >
            <X size={14} />
          </button>
        </div>
      )}

      {/* Messages area */}
      <div className="flex-1 overflow-y-auto py-4">
        {messages.length === 0 && !isLoading && (
          <div className="flex flex-col items-center justify-center h-full text-center p-8">
            <div className="neo-card p-6 max-w-md">
              <h3 className="font-display font-bold text-lg mb-2">
                仕様作成を開始
              </h3>
              <p className="text-sm text-[var(--color-neo-text-secondary)]">
                Claudeに接続してアプリ仕様の作成を支援します...
              </p>
              {connectionStatus === 'error' && (
                <button
                  onClick={start}
                  className="neo-btn neo-btn-primary mt-4 text-sm"
                >
                  <RotateCcw size={14} />
                  再接続
                </button>
              )}
            </div>
          </div>
        )}

        {messages.map((message) => (
          <ChatMessage key={message.id} message={message} />
        ))}

        {/* Structured questions */}
        {currentQuestions && currentQuestions.length > 0 && (
          <QuestionOptions
            questions={currentQuestions}
            onSubmit={handleAnswerSubmit}
            disabled={isLoading}
          />
        )}

        {/* Typing indicator - don't show when we have questions (waiting for user) */}
        {isLoading && !currentQuestions && <TypingIndicator />}

        {/* Scroll anchor */}
        <div ref={messagesEndRef} />
      </div>

      {/* Input area */}
      {!isComplete && (
        <div
          className="p-4 border-t-3 border-[var(--color-neo-border)] bg-white"
          onDrop={handleDrop}
          onDragOver={handleDragOver}
        >
          {/* Attachment previews */}
          {pendingAttachments.length > 0 && (
            <div className="flex flex-wrap gap-2 mb-3">
              {pendingAttachments.map((attachment) => (
                <div
                  key={attachment.id}
                  className="relative group border-2 border-[var(--color-neo-border)] p-1 bg-white shadow-[2px_2px_0px_rgba(0,0,0,1)]"
                >
                  <img
                    src={attachment.previewUrl}
                    alt={attachment.filename}
                    className="w-16 h-16 object-cover"
                  />
                  <button
                    onClick={() => handleRemoveAttachment(attachment.id)}
                    className="absolute -top-2 -right-2 bg-[var(--color-neo-danger)] text-white rounded-full p-0.5 border-2 border-[var(--color-neo-border)] hover:scale-110 transition-transform"
                    title="Remove attachment"
                  >
                    <X size={12} />
                  </button>
                  <span className="text-xs truncate block max-w-16 mt-1 text-center">
                    {attachment.filename.length > 10
                      ? `${attachment.filename.substring(0, 7)}...`
                      : attachment.filename}
                  </span>
                </div>
              ))}
            </div>
          )}

          <div className="flex gap-3">
            {/* Hidden file input */}
            <input
              ref={fileInputRef}
              type="file"
              accept="image/jpeg,image/png"
              multiple
              onChange={(e) => handleFileSelect(e.target.files)}
              className="hidden"
            />

            {/* Attach button */}
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={connectionStatus !== 'connected'}
              className="neo-btn neo-btn-ghost p-3"
              title="Attach image (JPEG, PNG - max 5MB)"
            >
              <Paperclip size={18} />
            </button>

            <input
              ref={inputRef}
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder={
                currentQuestions
                  ? 'または自由に入力...'
                  : pendingAttachments.length > 0
                    ? '画像と一緒にメッセージを追加...'
                    : '入力してください... (/exit でプロジェクトへ)'
              }
              className="neo-input flex-1"
              disabled={(isLoading && !currentQuestions) || connectionStatus !== 'connected'}
            />
            <button
              onClick={handleSendMessage}
              disabled={
                (!input.trim() && pendingAttachments.length === 0) ||
                (isLoading && !currentQuestions) ||
                connectionStatus !== 'connected'
              }
              className="neo-btn neo-btn-primary px-6"
            >
              <Send size={18} />
            </button>
          </div>

          {/* Help text */}
          <p className="text-xs text-[var(--color-neo-text-secondary)] mt-2">
            Enterで送信。ドラッグ＆ドロップまたは <Paperclip size={12} className="inline" /> で画像添付（JPEG/PNG、最大5MB）
          </p>
        </div>
      )}

      {/* Completion footer */}
      {isComplete && (
        <div className={`p-4 border-t-3 border-[var(--color-neo-border)] ${
          initializerStatus === 'error' ? 'bg-[var(--color-neo-danger)]' : 'bg-[var(--color-neo-done)]'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              {initializerStatus === 'starting' ? (
                <>
                  <Loader2 size={20} className="animate-spin" />
                  <span className="font-bold">
                    エージェント起動中{yoloEnabled ? '（YOLOモード）' : ''}...
                  </span>
                </>
              ) : initializerStatus === 'error' ? (
                <>
                  <AlertCircle size={20} className="text-white" />
                  <span className="font-bold text-white">
                    {initializerError || 'エージェント起動に失敗しました'}
                  </span>
                </>
              ) : (
                <>
                  <CheckCircle2 size={20} />
                  <span className="font-bold">仕様の作成が完了しました！</span>
                </>
              )}
            </div>
            <div className="flex items-center gap-2">
              {initializerStatus === 'error' && onRetryInitializer && (
                <button
                  onClick={onRetryInitializer}
                  className="neo-btn bg-white"
                >
                  <RotateCcw size={14} />
                  再試行
                </button>
              )}
              {initializerStatus === 'idle' && (
                <>
                  {/* YOLO Mode Toggle */}
                  <button
                    onClick={() => setYoloEnabled(!yoloEnabled)}
                    className={`neo-btn text-sm py-2 px-3 ${
                      yoloEnabled ? 'neo-btn-warning' : 'bg-white'
                    }`}
                    title="YOLOモード: テストをスキップして高速開発"
                  >
                    <Zap size={16} className={yoloEnabled ? 'text-yellow-900' : ''} />
                    <span className={yoloEnabled ? 'text-yellow-900 font-bold' : ''}>
                      YOLO
                    </span>
                  </button>
                  <button
                    onClick={() => onComplete('', yoloEnabled)}
                    className="neo-btn neo-btn-primary"
                  >
                    プロジェクトへ進む
                    <ArrowRight size={16} />
                  </button>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
