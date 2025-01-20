import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "progress"]
  
  connect() {
    this.activeTimers = 0
    this.totalSets = this.checkboxTargets.length
    this.completedSets = 0
  }

  start(event) {
    if (!event.target.checked) {
      this.completedSets--
      return
    }

    this.activeTimers++
    const duration = event.target.dataset.duration
    const id = event.target.id
    const setNum = id.split('_')[1]
    const exerciseId = id.split('_')[2]
    
    const startTime = Date.now()
    this.startTimer(startTime, duration, setNum, exerciseId)
  }

  startTimer(startTime, duration, setNum, exerciseId) {
    const progressBar = document.getElementById(`progress_${setNum}_${exerciseId}`)
    const progressBarInner = progressBar.querySelector('.progress-bar')
    const readyText = document.getElementById(`ready_${setNum}_${exerciseId}`)
    
    progressBar.classList.remove('d-none')
    
    const updateProgress = () => {
      const elapsed = Math.floor((Date.now() - startTime) / 1000)
      const percent = Math.min((elapsed / duration) * 100, 100)
      
      progressBarInner.style.width = `${percent}%`
      progressBarInner.textContent = `${elapsed}s`
      
      if (elapsed >= duration) {
        readyText.classList.remove('d-none')
        progressBar.classList.add('d-none')
        this.activeTimers--
        this.completedSets++
        this.checkCompletion()
      } else {
        requestAnimationFrame(updateProgress)
      }
    }
    
    requestAnimationFrame(updateProgress)
  }

  checkCompletion() {
    if (this.completedSets >= this.totalSets && this.activeTimers === 0) {
      this.element.querySelector('form').submit()
    }
  }
}
